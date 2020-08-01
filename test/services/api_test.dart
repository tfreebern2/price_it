import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
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
  });
}
