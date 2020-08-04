import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:priceit/datamodels/item.dart';
import 'package:priceit/services/api.dart';
import 'package:priceit/util/constants.dart';

import '../setup/test_helpers.dart';

void main() {
  group('Api Testing -', () {
    setUp(() => registerInitialServices());
    tearDown(() => unregisterApiService());

    test('When User Selects New Condition, Set IntValue to 1000', () {
      var api = Api();
      String intValue = '3000';
      expect(api.setConditionIntValue('New', intValue), '1000');
    });

    test('When User Selects New Or Other Condition, Set IntValue to 1500', () {
      var api = Api();
      String intValue = '3000';
      expect(api.setConditionIntValue('New or other', intValue), '1500');
    });

    test('When User Selects Used Condition, Set IntValue to 3000', () {
      var api = Api();
      String intValue = '3000';
      expect(api.setConditionIntValue('Used', intValue), '3000');
    });

    test('When User Selects Very Good Condition, Set IntValue to 4000', () {
      var api = Api();
      String intValue = '3000';
      expect(api.setConditionIntValue('Very Good', intValue), '4000');
    });

    test('When User Selects Good Condition, Set IntValue to 5000', () {
      var api = Api();
      String intValue = '3000';
      expect(api.setConditionIntValue('Good', intValue), '5000');
    });

    test('When User Selects Acceptable Condition, Set IntValue to 6000', () {
      var api = Api();
      String intValue = '3000';
      expect(api.setConditionIntValue('Acceptable', intValue), '6000');
    });

    test('validate keyword in post request body', () {
      var api = Api();
      String requestBody = api.buildCompletedItemSearchRequest('Used', 'iPhone 6');
      var decodedRequestBody = jsonDecode(requestBody);
      expect(decodedRequestBody[keywords], 'iPhone 6');
    });

    test('validate best match sort order in post request body', () {
      var api = Api();
      String requestBody = api.buildCompletedItemSearchRequest('New', 'iphone 6');
      var decodedRequestBody = jsonDecode(requestBody);
      expect(decodedRequestBody[sortOrder], 'BestMatch');
    });

    test('Search for completed listings and successfully parse for completed items from response body', () async {
      var api = Api();
      final responseFile = new File('test/setup/data/new_completed_listing_response.json');
      List list = api.decodeResponse(await responseFile.readAsString());
      LinkedHashMap linkedHashMap = list.firstWhere((item) => item[sellingStatusKey][0][sellingStateKey][0] == ended, orElse: () => null);
      expect(linkedHashMap.isNotEmpty, true);
    });

    test('Search for active listings and successfully parse for active items from response body', () async {
      var api = Api();
      final responseFile = new File('test/setup/data/new_active_listing_response.json');
      List list = api.decodeResponse(await responseFile.readAsString());
      LinkedHashMap linkedHashMap = list.firstWhere((item) => item[sellingStatusKey][0][sellingStateKey][0] == active, orElse: () => null);
      expect(linkedHashMap.isNotEmpty, true);
    });

    test('Find total entries for completed items api call', () async {
      var api = Api();
      final responseFile = new File('test/setup/data/new_completed_listing_response.json');
      List list = api.findTotalEntries(await responseFile.readAsString());
      expect(list[0], "113751");
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
      final responseFile = new File('test/setup/data/new_completed_listing_response.json');
      List list = api.decodeResponse(await responseFile.readAsString());
      expect(api.getItemList(list, "113751").length, 25);
    });

    test('Set total entries to first item of Item List', () async{
      var api = Api();
      final responseFile = new File('test/setup/data/new_completed_listing_response.json');
      List list = api.decodeResponse(await responseFile.readAsString());
      expect(api.getItemList(list, "113751")[0].totalEntries, "113751");
      expect(api.getItemList(list, "113751")[1].totalEntries, null);
    });

    test('Validate first item from completed list call from GetListItem function', () async {
      var api = Api();
      final responseFile = new File('test/setup/data/new_completed_listing_response.json');
      List list = api.decodeResponse(await responseFile.readAsString());
      List<Item> itemList = api.getItemList(list, "113751");
      expect(itemList[0].id, "192623364441");
      expect(itemList[0].title, "Rainbow Bear 3D Cartoon Silicone Phone Case For iPhone 11 Pro Max XR 6s/7/8/Plus");
      expect(itemList[0].globalId, "EBAY-US");
      expect(itemList[0].galleryUrl, "https://thumbs1.ebaystatic.com/pict/04040_0.jpg");
      expect(itemList[0].viewItemUrl, "https://www.ebay.com/itm/Rainbow-Bear-3D-Cartoon-Silicone-Phone-Case-iPhone-11-Pro-Max-XR-6s-7-8-Plus-/192623364441?var=0");
      expect(itemList[0].location, "China");
      expect(itemList[0].country, "CN");
      expect(itemList[0].totalEntries, "113751");
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
  });
}
