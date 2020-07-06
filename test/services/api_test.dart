import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:priceit/datamodels/item.dart';
import 'package:priceit/services/api.dart';
import 'package:priceit/util/constants.dart';

void main() async {
  final api = Api();
//  await DotEnv().load('../../.env');

  test('validate item list length', () {
    Future<List<Item>> items = api.searchForCompletedItems('Used', 'iphone 6');
    items.then((value) => expect(items.asStream().length, 100));
  });

  test('validate keyword in post request body', () {
    String requestBody = api.buildCompletedItemSearchRequest('Used', 'iphone 6');
    var decodedRequestBody = jsonDecode(requestBody);
    expect(decodedRequestBody[keywords], 'iphone 6');
  });

  test('validate int value for used condition in post request body', () {
    String requestBody = api.buildCompletedItemSearchRequest('Used', 'iphone 6');
    var decodedRequestBody = jsonDecode(requestBody);
    expect(decodedRequestBody[itemFilter][0][valueKey], '3000');
  });

  test('validate int value for new condition in post request body', () {
    String requestBody = api.buildCompletedItemSearchRequest('New', 'iphone 6');
    var decodedRequestBody = jsonDecode(requestBody);
    expect(decodedRequestBody[itemFilter][0][valueKey], '1000');
  });

  test('validate best match sort order in post request body', () {
    String requestBody = api.buildCompletedItemSearchRequest('New', 'iphone 6');
    var decodedRequestBody = jsonDecode(requestBody);
    expect(decodedRequestBody[sortOrder], 'BestMatch');
  });
}
