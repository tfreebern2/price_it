import 'dart:convert';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:priceit/datamodels/item.dart';
import 'package:injectable/injectable.dart';
import 'package:http/http.dart' as http;

import 'package:priceit/util/constants.dart';

@lazySingleton
class Api {
  var client = new http.Client();

  Future<List<Item>> searchForCompletedItems(String selectorValue, String searchKeyword) async {
    String requestBody = buildCompletedItemSearchRequest(selectorValue, searchKeyword);
    http.Response response = await _findingCompletedItemApiCall(requestBody);
    List decodedItemList = _decodeResponse(response);
    return _getItemList(decodedItemList, response);
  }

  Future<List<Item>> searchForActiveItems(String selectorValue, String searchKeyword) async {
    String requestBody = buildActiveItemSearchRequest(selectorValue, searchKeyword);
    http.Response response = await _findingActiveItemApiCall(requestBody);
    List decodedItemList = _decodeResponse(response);
    return _getItemList(decodedItemList, response);
  }

  Future<List<Item>> searchForItemsByProduct(String productType, String productId) async {
    String requestBody = buildProductItemSearchRequest(productType, productId);
    http.Response response = await _findingProduct(requestBody);
    List decodedItemList = _decodeResponse(response);
    return _getItemList(decodedItemList, response);
  }

  String buildCompletedItemSearchRequest(String selectorValue, String searchKeyword) {
    String intValue = '3000';
    intValue = _setConditionIntValue(selectorValue, intValue);

    var requestBody = jsonEncode({
      keywords: searchKeyword,
      itemFilter: [
        {nameKey: condition, valueKey: intValue},
        {nameKey: soldItemsOnly, valueKey: trueString}
      ],
      sortOrder: bestMatch,
      paginationInput: {entriesPerPage: oneHundred, pageNumber: one}
    });

    return requestBody;
  }

  String buildProductItemSearchRequest(String productType, String productId) {
    var requestBody = '<?xml version="1.0" encoding="UTF-8"?>'
            '<findItemsByProductRequest xmlns="http://www.ebay.com/marketplace/search/v1/services">' +
        '<productId type=' + '"' + productType + '"' + '>' + productId + '</productId>' +
        '<paginationInput><entriesPerPage>25</entriesPerPage></paginationInput></findItemsByProductRequest>';
    return requestBody;
  }

  String buildActiveItemSearchRequest(String selectorValue, String searchKeyword) {
    String intValue = '3000';
    intValue = _setConditionIntValue(selectorValue, intValue);

    var requestBody = jsonEncode({
      keywords: searchKeyword,
      itemFilter: [
        {nameKey: condition, valueKey: intValue},
        {nameKey: hideDuplicateItems, valueKey: trueString}
      ],
      sortOrder: bestMatch,
      paginationInput: {entriesPerPage: oneHundred, pageNumber: one}
    });

    return requestBody;
  }

  String _setConditionIntValue(String selectorValue, String intValue) {
    conditionsMap.forEach((key, value) {
      if (key == selectorValue) {
        intValue = value;
      }
    });
    return intValue;
  }

  Future<http.Response> _findingCompletedItemApiCall(var body) async {
    final response =
        await client.post(findingServiceUrl, headers: completedItemsHeaders, body: body);
    debugPrint("Search Completed Listings - Response Code: " + response.statusCode.toString());
    return response;
  }

  Future<http.Response> _findingActiveItemApiCall(var body) async {
    final response = await client.post(findingServiceUrl, headers: activeItemsHeaders, body: body);
    debugPrint("Search Active Listings - Response Code: " + response.statusCode.toString());
    return response;
  }

  Future<http.Response> _findingProduct(var body) async {
    final response =
        await client.post(findingServiceUrl, headers: productItemsHeaders, body: body);
    debugPrint("Search Product - Response Code: " + response.statusCode.toString());
    return response;
  }

  List _decodeResponse(http.Response response) {
    var decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;
    if (decodedResponse.containsKey(findCompletedItemsResponse)) {
      return decodedResponse[findCompletedItemsResponse][0][searchResult][0][item] as List;
    } else {
      return decodedResponse[findItemsByKeywordsResponse][0][searchResult][0][item] as List;
    }
  }

  List<Item> _getItemList(List decodedItemList, http.Response response) {
    List<Item> itemList = List<Item>();
    decodedItemList.forEach((json) {
      if (itemList.isEmpty) {
        Item item = Item.fromMap(json);
        List totalEntries = findTotalEntries(response);
        item.totalEntries = totalEntries[0];
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

  List findTotalEntries(http.Response response) {
    var decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;
    if (decodedResponse.containsKey(findCompletedItemsResponse)) {
      return decodedResponse[findCompletedItemsResponse][0][paginationOutput][0][totalEntries]
          as List;
    } else {
      return decodedResponse[findItemsByKeywordsResponse][0][paginationOutput][0][totalEntries]
          as List;
    }
  }
}
