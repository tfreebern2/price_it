import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:priceit/datamodels/ebay_request.dart';
import 'package:priceit/datamodels/item.dart';
import 'package:injectable/injectable.dart';
import 'package:http/http.dart' as http;

import 'package:priceit/util/constants.dart';

@lazySingleton
class Api {
  var client = new http.Client();

  Future<List<Item>> searchForActiveItems(EbayRequest request) async {
    String requestBody = buildActiveItemSearchRequest(request.condition, request.keyword);
    String ebayGlobalId = mapRegionToEbayGlobalId(request.region);
    Map<String, String> requestHeaders = buildRequestHeaders(ebayGlobalId);
    http.Response response = await _findingActiveItemApiCall(requestBody, requestHeaders);
    List decodedItemList = decodeResponse(response.body);
    List totalEntriesList = findTotalEntries(response.body);
    String totalEntries = totalEntriesList.isNotEmpty ? totalEntriesList[0] : "0";
    return getItemList(decodedItemList, totalEntries);
  }

  String buildActiveItemSearchRequest(String selectorValue, String searchKeyword) {
    if (selectorValue == newValue) {
      var requestBody = jsonEncode({
        keywords: searchKeyword,
        itemFilter: [
          {
            nameKey: condition,
            valueKey: [newValue, "1500"]
          },
          {nameKey: hideDuplicateItems, valueKey: trueString}
        ],
        sortOrder: bestMatch,
        paginationInput: {entriesPerPage: oneHundred, pageNumber: one}
      });
      debugPrint(requestBody);
      return requestBody;
    } else {
      var requestBody = jsonEncode({
        keywords: searchKeyword,
        itemFilter: [
          {
            nameKey: condition,
            valueKey: [usedValue, "4000", "5000", "6000"]
          },
          {nameKey: hideDuplicateItems, valueKey: trueString}
        ],
        sortOrder: bestMatch,
        paginationInput: {entriesPerPage: oneHundred, pageNumber: one}
      });
      debugPrint(requestBody);
      return requestBody;
    }
  }

  Map<String, String> buildRequestHeaders(String ebayGlobalId) {
    return {
      HttpHeaders.contentTypeHeader: 'application/json',
      appNameHeader: appId,
      operationNameHeader: findItemsByKeywords,
      serviceVersionHeader: serviceVersionHeaderValue,
      globalIdHeader: ebayGlobalId,
      serviceNameHeader: serviceNameHeaderValue,
      requestDataFormatHeader: json,
      responseDataFormatHeader: json
    };
  }

  String mapRegionToEbayGlobalId(String region) {
    return regionsMap[region];
  }

  Future<http.Response> _findingActiveItemApiCall(var body, Map<String, String> requestHeaders) async {
    debugPrint("Body: " + body);
    debugPrint("Request Headers: " + requestHeaders.toString());
    try {
      final response =
          await client.post(findingServiceUrl, headers: requestHeaders, body: body);
      debugPrint("Search Active Listings - Response Code: " + response.statusCode.toString());
      return response;
    } on Exception catch (e) {
      debugPrint(e.toString());
      throw Exception("Error making API request to eBay: " + e.toString());
    }
  }

  List decodeResponse(String responseBody) {
    var decodedResponse = jsonDecode(responseBody) as Map<String, dynamic>;

    if (decodedResponse.containsKey(findItemsByKeywordsResponse)) {
      return decodedResponse[findItemsByKeywordsResponse][0][searchResult][0][item] as List;
    } else {
      throw Exception("Error decoding response from eBay: " + responseBody);
    }
  }

  List<Item> getItemList(List decodedItemList, String totalEntries) {
    if (decodedItemList.isEmpty) {
      return new List<Item>();
    }

    List<Item> itemList = List<Item>();
    decodedItemList.forEach((json) {
      if (itemList.isEmpty) {
        Item item = Item.fromJson(json);
        item.totalEntries = totalEntries;
        itemList.add(item);
      } else {
        if (itemList.length >= 100) {
          return;
        }
        Item item = Item.fromJson(json);
        itemList.add(item);
      }
    });
    return itemList;
  }

  List findTotalEntries(String responseBody) {
    var decodedResponse = jsonDecode(responseBody) as Map<String, dynamic>;

    return decodedResponse[findItemsByKeywordsResponse][0][paginationOutput][0][totalEntries]
        as List;
  }
}
