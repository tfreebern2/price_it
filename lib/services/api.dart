import 'dart:io';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:priceit/datamodels/item.dart';
import 'package:injectable/injectable.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:priceit/util/constants.dart';

@lazySingleton
class Api {
  var client = new http.Client();

  Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
    appNameHeader: DotEnv().env['APP_ID'],
    operationNameHeader: operationHeaderValue,
    serviceVersionHeader: serviceVersionHeaderValue,
    globalIdHeader: globalIdHeaderValue,
    serviceNameHeader: serviceNameHeaderValue,
    requestDataFormatHeader: requestDataFormatHeaderValue,
    responseDataFormatHeader: responseDataFormatHeaderValue
  };


  Future<List<Item>> searchForItems() async {
    Map data = {'keywords': 'iphone 6'};
    http.Response response = await _findingServiceApiCall(data);
    var decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;
    var decodedItemList = decodedResponse['findItemsByKeywordsResponse'][0]
        ['searchResult'][0]['item'] as List;
    return _getItemList(decodedItemList);
  }

  Future<http.Response> _findingServiceApiCall(Map data) async {
    final response = await client.post(findingServiceUrl,
        headers: headers, body: json.encode(data));
    debugPrint("Response Code: " + response.statusCode.toString());
    return response;
  }

  List<Item> _getItemList(List decodedItemList) {
    List<Item> itemList = List<Item>();
    decodedItemList.forEach((json) {
      Item item2 = Item.fromMap(json);
      itemList.add(item2);
    });

    return itemList;
  }
}
