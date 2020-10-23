import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:priceit/datamodels/item.dart';
import 'package:priceit/services/api.dart';
import 'package:priceit/util/constants.dart';

import '../setup/test_helpers.dart';

void main() {
  group('Api Testing -', () {
    setUp(() => registerInitialServices());
    tearDown(() => unregisterApiService());

    test('validate condition values for New condition on Active List Request', () {
      var api = Api();
      String requestBody = api.buildActiveItemSearchRequest('New', 'iphone 6');
      var decodedRequestBody = jsonDecode(requestBody);
      expect(decodedRequestBody["itemFilter"][0]["value"], [newValue, "1500"]);
    });

    test('validate condition values for Used condition on Active List Request', () {
      var api = Api();
      String requestBody = api.buildActiveItemSearchRequest('Old', 'iphone 6');
      var decodedRequestBody = jsonDecode(requestBody);
      expect(decodedRequestBody["itemFilter"][0]["value"], [usedValue, "4000", "5000", "6000"]);
    });

    test('return EBAY-ENCA if Canada (English) is selected', () {
      var api = Api();
      String map = api.mapRegionToEbayGlobalId('Canada (English)');
      expect(map, 'EBAY-ENCA');
    });

    test('return EBAY-PL if Poland is selected', () {
      var api = Api();
      String map = api.mapRegionToEbayGlobalId('Poland');
      expect(map, 'EBAY-PL');
    });

    test('Search for active listings and successfully parse for active items from response body', () async {
      var api = Api();
      final responseFile = new File('test/setup/data/new_active_listing_response.json');
      List list = api.decodeResponse(await responseFile.readAsString());
      LinkedHashMap linkedHashMap = list.firstWhere((item) => item[sellingStatusKey][0][sellingStateKey][0] == active, orElse: () => null);
      expect(linkedHashMap.isNotEmpty, true);
    });

    test('Find total entries for active items api call', () async {
      var api = Api();
      final responseFile = new File('test/setup/data/new_active_listing_response.json');
      List list = api.findTotalEntries(await responseFile.readAsString());
      expect(list[0], "5185831");
    });

    test('Return List of Empty Items if Api response is empty', () {
      var api = Api();
      expect(api.getItemList(new List(), "0"), new List<Item>());
    });

    test('If response contains more than 25 total entries, only return 25 items', () async{
      var api = Api();
      final responseFile = new File('test/setup/data/new_active_listing_response.json');
      List list = api.decodeResponse(await responseFile.readAsString());
      expect(api.getItemList(list, "113751").length, 25);
    });

    test('Set total entries to first item of Item List', () async{
      var api = Api();
      final responseFile = new File('test/setup/data/new_active_listing_response.json');
      List list = api.decodeResponse(await responseFile.readAsString());
      expect(api.getItemList(list, "113751")[0].totalEntries, "113751");
      expect(api.getItemList(list, "113751")[1].totalEntries, null);
    });

    test('Validate first item from active list call from GetListItem function', () async {
      var api = Api();
      final responseFile = new File('test/setup/data/new_active_listing_response.json');
      List list = api.decodeResponse(await responseFile.readAsString());
      List<Item> itemList = api.getItemList(list, "5185831");
      expect(itemList[0].id, "164313213241");
      expect(itemList[0].title, "MIB UNUSED! Apple iPhone 6 64GB Space Gray A1549");
      expect(itemList[0].globalId, "EBAY-US");
      expect(itemList[0].galleryUrl, "https://thumbs2.ebaystatic.com/m/mbME0GKvi3NN-HAOPo0ONSw/140.jpg");
      expect(itemList[0].viewItemUrl, "https://www.ebay.com/itm/MIB-UNUSED-Apple-iPhone-6-64GB-Space-Gray-A1549-/164313213241");
      expect(itemList[0].location, "Bellevue,WA,USA");
      expect(itemList[0].country, "US");
      expect(itemList[0].totalEntries, "5185831");
    });

    test('Get currency type', () async {
      var api = Api();
      final responseFile = new File('test/setup/data/new_active_listing_response.json');
      List list = api.decodeResponse(await responseFile.readAsString());
      var sellingStatusMap = list[0] as Map<String, dynamic>;

      debugPrint(sellingStatusMap.toString());
    });
  });
}
