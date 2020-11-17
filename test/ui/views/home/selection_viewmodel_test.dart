import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:priceit/app/router.gr.dart';
import 'package:priceit/datamodels/item.dart';
import 'package:priceit/ui/views/home/selection_viewmodel.dart';

import '../../../setup/test_helpers.dart';

void main() {
  group('SelectionViewModelTest -', () {
    setUp(() => registerInitialServices());
    tearDown(() => unregisterServices());

    test('When search button is tapped, clear stack and show Selection View', () async {
      var navigationService = getAndRegisterNavigationServiceMock();
      var model = SelectionViewModel();
      model.navigateToKeyword();
      verify(navigationService.navigateTo(Routes.keywordSearchView));
    });

    test('When completed view listing button is tapped, replace view with Completed View Listing', () async {
      var navigationService = getAndRegisterNavigationServiceMock();
      var model = SelectionViewModel();
      model.navigateToProduct();
      verify(navigationService.navigateTo(Routes.productSearchHomeView));
    });

    test('bs', () {
      List<Item> activeItemListing = new List();
      Item item1 =
      new Item("1", "title", "1234", "ebay.com", "ebay.com", "United States", "US", "\$", 47.00, "SOLD");
      Item item2 =
      new Item("1", "title", "1234", "ebay.com", "ebay.com", "United States", "US", "\$", 122.99, "SOLD");
      Item item3 =
      new Item("1", "title", "1234", "ebay.com", "ebay.com", "United States", "US", "\$", 133.11, "SOLD");
      activeItemListing.add(item1);
      activeItemListing.add(item2);
      activeItemListing.add(item3);
      activeItemListing.sort((a, b) => b.currentPrice.compareTo(a.currentPrice));
      print(activeItemListing);
    });
  });
}