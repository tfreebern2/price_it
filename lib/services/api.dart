import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:priceit/app/locator.dart';
import 'package:priceit/datamodels/item.dart';
import 'package:injectable/injectable.dart';
import 'package:http/http.dart' as http;
import 'package:priceit/services/search_service.dart';

import 'package:priceit/util/constants.dart';

@lazySingleton
class Api {
  var client = new http.Client();
  final searchService = locator<SearchService>();

  Future<List<Item>> searchForCompletedItems(String selectorValue, String searchKeyword, String region) async {
    resetApiServiceCalls();
    String requestBody = buildCompletedItemSearchRequest(selectorValue, searchKeyword);
    http.Response response = await findingCompletedItemApiCall(requestBody, region);
    List decodedItemList = decodeResponse(response.body);
    List totalEntriesList = findTotalEntries(response.body);
    String totalEntries = totalEntriesList.isNotEmpty ? totalEntriesList[0] : "0";
    return getItemList(decodedItemList, totalEntries);
  }

  Future<List<Item>> searchForActiveItems(String selectorValue, String searchKeyword) async {
    String requestBody = buildActiveItemSearchRequest(selectorValue, searchKeyword);
    http.Response response = await _findingActiveItemApiCall(requestBody);
    List decodedItemList = decodeResponse(response.body);
    List totalEntriesList = findTotalEntries(response.body);
    String totalEntries = totalEntriesList.isNotEmpty ? totalEntriesList[0] : "0";
    return getItemList(decodedItemList, totalEntries);
  }

  String buildCompletedItemSearchRequest(String selectorValue, String searchKeyword) {
    if (selectorValue == newValue) {
        var requestBody = jsonEncode({
          keywords: searchKeyword,
          itemFilter: [
            {
              nameKey: condition,
              valueKey: [newValue, "1500"]
            },
            {nameKey: soldItemsOnly, valueKey: trueString}
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
          {nameKey: soldItemsOnly, valueKey: trueString}
        ],
        sortOrder: bestMatch,
        paginationInput: {entriesPerPage: oneHundred, pageNumber: one}
      });
      debugPrint(requestBody);
      return requestBody;
    }
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

  String setConditionIntValue(String selectorValue, String intValue) {
    conditionsMap.forEach((key, value) {
      if (key == selectorValue) {
        intValue = value;
      }
    });
    return intValue;
  }

  Future<http.Response> findingCompletedItemApiCall(var body, String region) async {
    try {
      final response =
          await client.post(findingServiceUrl, headers: buildCompletedItemHeader(region), body: body);
      debugPrint("Search Completed Listings - Response Code: " + response.statusCode.toString());
      return response;
    } on Exception catch (e) {
      throw Exception(
          "Error making API request to eBay: " + e.toString());
    }
  }

  Map<String, String> buildCompletedItemHeader(String region) {
    String globalId = _getGlobalId(region);
    Map<String, String> completedItemsHeaders = {
      HttpHeaders.contentTypeHeader: 'application/json',
      appNameHeader: DotEnv().env['APP_ID'],
      operationNameHeader: findCompletedItems,
      serviceVersionHeader: serviceVersionHeaderValue,
      globalIdHeader: globalId,
      serviceNameHeader: serviceNameHeaderValue,
      requestDataFormatHeader: json,
      responseDataFormatHeader: json
    };
    return completedItemsHeaders;
  }

  String _getGlobalId(String region) {
    regionsMap.forEach((key, value) {
      if (key == region) {
        return value;
      }
    });
    return globalIdHeaderValue;
  }

  Future<http.Response> _findingActiveItemApiCall(var body) async {
    try {
      final response =
          await client.post(findingServiceUrl, headers: activeItemsHeaders, body: body);
      debugPrint("Search Active Listings - Response Code: " + response.statusCode.toString());
      return response;
    } on Exception catch (e) {
      throw Exception("Error making API request to eBay: " + e.toString());
    }
  }

  List decodeResponse(String responseBody) {
    var decodedResponse = jsonDecode(responseBody) as Map<String, dynamic>;

    if (decodedResponse.containsKey(findCompletedItemsResponse)) {
      return decodedResponse[findCompletedItemsResponse][0][searchResult][0][item] as List;
    } else if (decodedResponse.containsKey(findItemsByKeywordsResponse)) {
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
        Item item = Item.fromMap(json);
        item.totalEntries = totalEntries;
        itemList.add(item);
      } else {
        if (itemList.length >= 25) {
          return;
        }
        Item item = Item.fromMap(json);
        itemList.add(item);
      }
    });
    return itemList;
  }

  List findTotalEntries(String responseBody) {
    var decodedResponse = jsonDecode(responseBody) as Map<String, dynamic>;

    if (decodedResponse.containsKey(findCompletedItemsResponse)) {
      return decodedResponse[findCompletedItemsResponse][0][paginationOutput][0][totalEntries]
          as List;
    } else {
      return decodedResponse[findItemsByKeywordsResponse][0][paginationOutput][0][totalEntries]
          as List;
    }
  }

  void resetApiServiceCalls() {
    searchService.setApiError(false);
    searchService.setApiCalled(false);
  }
}
