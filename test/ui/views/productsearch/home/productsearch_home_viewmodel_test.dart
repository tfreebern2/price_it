import 'package:flutter_test/flutter_test.dart';
import 'package:priceit/ui/views/productsearch/home/productsearch_home_viewmodel.dart';

import '../../../../setup/test_helpers.dart';

void main() {
  group('ProductSearchHomeViewModelTest -', () {
    setUp(() => registerInitialServices());
    tearDown(() => unregisterServices());

    test('When search button is tapped, clear stack and show Selection View', () async {
      var model = ProductSearchHomeViewModel();
      model.initialise();
    });

    test('When completed view listing button is tapped, replace view with Completed View Listing', () async {
      var model = ProductSearchHomeViewModel();
      model.initialise();
    });

    test('test camera functionality', () {
    });
  });
}