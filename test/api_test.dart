import 'package:flutter_test/flutter_test.dart';
import 'package:priceit/datamodels/item.dart';
import 'package:priceit/services/api.dart';

void main() {
  test('validate json response', () {
    final api = Api();
    Future<List<Item>> items = api.searchForItems('iphone 6');
    items.then((value) => expect(items.asStream().length, 100));
  });
}
