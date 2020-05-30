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

  Future<List<Item>> searchForItems(String selectorValue, String searchKeyword) async {
    String requestBody = _buildSearchRequest(selectorValue, searchKeyword);
    http.Response response = await _findingServiceApiCall(requestBody);
    List decodedItemList = _decodeResponse(response);
    return _getItemList(decodedItemList);
  }

  String _buildSearchRequest(String selectorValue, String searchKeyword) {
    String intValue = '3000';
    intValue = _setConditionIntValue(selectorValue, intValue);

    var requestBody = jsonEncode({
      keywords: searchKeyword,
      itemFilter: [
        {nameKey: condition, valueKey: intValue}
      ]
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

  Future<http.Response> _findingServiceApiCall(var body) async {
    final response =
        await client.post(findingServiceUrl, headers: headers, body: body);
    debugPrint("Search - Response Code: " + response.statusCode.toString());
    return response;
  }

  List _decodeResponse(http.Response response) {
    var decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;
    var decodedItemList = decodedResponse[findItemsByKeywordsResponse][0][searchResult][0][item] as List;
    return decodedItemList;
  }

  List<Item> _getItemList(List decodedItemList) {
    List<Item> itemList = List<Item>();
    decodedItemList.forEach((json) {
      Item item = Item.fromMap(json);
      itemList.add(item);
    });

    return itemList;
  }
}
