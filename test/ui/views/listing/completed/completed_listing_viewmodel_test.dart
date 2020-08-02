import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:priceit/app/router.gr.dart';
import 'package:priceit/datamodels/item.dart';
import 'package:priceit/ui/views/listing/completed/completed_listing_viewmodel.dart';

import '../../../../setup/test_helpers.dart';

void main() {
  group('CompletedListingViewModelTest -', () {
    setUp(() => registerInitialServices());
    tearDown(() => unregisterServices());

    test('Initial Completed Listing Average Price is Zero', () async {
      var model = CompletedListingViewModel();
      await model.initialise();
      expect(model.completedListingAveragePrice, 0.00);
    });

    test('Initial Active Listing Average Price is Zero', () async {
      var model = CompletedListingViewModel();
      await model.initialise();
      expect(model.activeListingAveragePrice, 0.00);
    });

    test('Initial Completed Listing Percentage Sold is Zero', () async {
      var model = CompletedListingViewModel();
      await model.initialise();
      expect(model.completedListingPercentageSold, 0.00);
    });

    test('When user taps search button, clear stack and show Selection View', () async {
      var navigationService = getAndRegisterNavigationServiceMock();
      var model = CompletedListingViewModel();
      await model.initialise();
      model.navigateToSelectionView();
      verify(navigationService.clearStackAndShow(Routes.selectionView));
    });

    test('When user taps search button, show Active View Listing', () async {
      var navigationService = getAndRegisterNavigationServiceMock();
      var model = CompletedListingViewModel();
      await model.initialise();
      model.navigateToActiveListingView();
      verify(navigationService.navigateTo(Routes.activeListingView));
    });

    test('When initially loading Completed View Model, return false on checkIfSavedApiCall & '
        'empty Search Service Completed & Active Listing Lists', () async {
      var searchService = getAndRegisterInitialSearchServiceMock();
      var model = CompletedListingViewModel();
      await model.initialise();
      expect(searchService.completedListing.isEmpty, true);
      expect(searchService.activeListing.isEmpty, true);
      expect(model.checkIfSavedApiCall(), false);
    });

    test('When only 1 Completed Sold Item and 0 Active Items, calculated 100% Sale Through Rate', () async {
      var model = CompletedListingViewModel();
      await model.initialise();
      List<Item> completedListing = new List();
      List<Item> activeListing = new List();
      Item item1 =
      new Item("1", "title", "global-id", "ebay.com/gallery", "ebay.com/viewItemUrl", "location", "country", "1.00", "SOLD");
      item1.totalEntries = "1";
      completedListing.add(item1);
      model.calculateSaleThroughRateAndAveragePrice(completedListing, activeListing);
      expect(model.completedListingPercentageSold, 100.00);
    });

    test('When only 1 Completed Sold Item and 1 Active Items, calculated 50% Sale Through Rate', () async {
      var model = CompletedListingViewModel();
      await model.initialise();
      List<Item> completedListing = new List();
      List<Item> activeListing = new List();
      Item item1 =
      new Item("1", "title", "global-id", "ebay.com/gallery", "ebay.com/viewItemUrl", "location", "country", "1.00", "SOLD");
      item1.totalEntries = "1";
      completedListing.add(item1);
      activeListing.add(item1);
      model.calculateSaleThroughRateAndAveragePrice(completedListing, activeListing);
      expect(model.completedListingPercentageSold, 50.00);
    });

    test('Item 1 is 1.00 & Item 2 is 10.00, Completed Listing Average Price equals 5.5', () async {
      var model = CompletedListingViewModel();
      await model.initialise();
      List<Item> completedListing = new List();
      List<Item> activeListing = new List();
      Item item1 = new Item("1", "title", "global-id", "ebay.com/gallery", "ebay.com/viewItemUrl", "location", "country", "1.00", "SOLD");
      item1.totalEntries = "1";
      Item item2 = new Item("2", "title", "global-id", "ebay.com/gallery", "ebay.com/viewItemUrl", "location", "country", "10.00", "SOLD");
      completedListing.add(item1);
      completedListing.add(item2);
      model.calculateSaleThroughRateAndAveragePrice(completedListing, activeListing);
      expect(model.completedListingAveragePrice, 5.5);
    });

    test('Item 1 is 12.00 & Item 2 is 10.00, Active Listing Average Price equals 11.0', () async {
      var model = CompletedListingViewModel();
      await model.initialise();
      List<Item> completedListing = new List();
      List<Item> activeListing = new List();
      Item item1 = new Item("1", "title", "global-id", "ebay.com/gallery", "ebay.com/viewItemUrl", "location", "country", "12.00", "SOLD");
      item1.totalEntries = "1";
      Item item2 = new Item("2", "title", "global-id", "ebay.com/gallery", "ebay.com/viewItemUrl", "location", "country", "10.00", "SOLD");
      activeListing.add(item1);
      activeListing.add(item2);
      model.calculateSaleThroughRateAndAveragePrice(completedListing, activeListing);
      expect(model.activeListingAveragePrice, 11.0);
    });

    test('10 Completed Items and 10 Active Items, calculated 20 Total Entries', () async {
      var model = CompletedListingViewModel();
      await model.initialise();
      List<Item> completedListing = new List();
      List<Item> activeListing = new List();
      Item item1 =
      new Item("1", "title", "global-id", "ebay.com/gallery", "ebay.com/viewItemUrl", "location", "country", "1.00", "SOLD");
      item1.totalEntries = "10";
      completedListing.add(item1);
      activeListing.add(item1);
      model.calculateSaleThroughRateAndAveragePrice(completedListing, activeListing);
      expect(model.totalEntries, 20);
    });
  });

  group('Load Completed View Listing after navigating back from Active View Listing ', () {
    setUp(() => registerSavedServices());
    tearDown(() => unregisterServices());

    test('Build from Saved Ebay Response', () async {
      var model = CompletedListingViewModel();
      await model.initialise();
      await model.buildSavedEbayResponse();
      expect(model.data.completedListingPercentageSold, 100.00);
    });
  });
}