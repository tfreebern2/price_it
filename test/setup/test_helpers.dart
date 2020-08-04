import 'dart:async';
import 'dart:io';

import 'package:mockito/mockito.dart';
import 'package:priceit/app/locator.dart';
import 'package:priceit/datamodels/item.dart';
import 'package:priceit/services/api.dart';
import 'package:priceit/services/search_service.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:http/http.dart' as http;

class MockClient extends Mock implements http.Client {}

class ApiMock extends Mock implements Api {}

class SearchServiceMock extends Mock implements SearchService {}

class NavigationServiceMock extends Mock implements NavigationService {}

class DialogServiceMock extends Mock implements DialogService {}

Future<ApiMock> getAndRegisterApiMock() async {
  _removeRegistrationIfExists<Api>();
  var api = ApiMock();

  final requestFile = new File('test/setup/data/new_completed_listing_request.json');
  final responseFile = new File('test/setup/data/new_completed_listing_response.json');

  List<Item> newCompletedListing = List<Item>();

  Item item1 =
      new Item("1", "title", "1234", "ebay.com", "ebay.com", "United States", "US", "1.00", "SOLD");
  newCompletedListing.add(item1);
  var futureCompletedListing = Future.value(newCompletedListing);

  // stubbing futures
  final futureRequest1 = Future.value(requestFile.readAsString());
  final futureResponse1 = Future.value(responseFile.readAsString());

  when(api.findingCompletedItemApiCall(futureRequest1))
      .thenAnswer((_) async => http.Response(await futureResponse1, 200));
  when(api.searchForCompletedItems('New', 'iPhone 6 ')).thenAnswer((_) async => futureCompletedListing);
  when(api.searchForActiveItems('New', 'iPhone 6 ')).thenAnswer((_) async => futureCompletedListing);

  locator.registerSingleton<Api>(api);
  return api;
}

SearchServiceMock getAndRegisterSavedSearchServiceMock() {
  _removeRegistrationIfExists<SearchService>();
  var service = SearchServiceMock();
  List<Item> completedListing = new List();
  List<Item> activeListing = new List();
  Item item1 =
      new Item("1", "title", "1234", "ebay.com", "ebay.com", "United States", "US", "1.00", "SOLD");
  item1.totalEntries = "1";
  completedListing.add(item1);
  activeListing.add(item1);
  service.setCompletedListing(completedListing);
  service.setActiveListing(activeListing);

  // stubbing

  when(service.completedListing).thenReturn(completedListing);
  when(service.activeListing).thenReturn(activeListing);
  when(service.completedListingAveragePrice).thenReturn(1.00);
  when(service.completedListingPercentageSold).thenReturn(100.00);
  when(service.activeListingAveragePrice).thenReturn(1.00);

  locator.registerSingleton<SearchService>(service);
  return service;
}

SearchServiceMock getAndRegisterInitialSearchServiceMock() {
  _removeRegistrationIfExists<SearchService>();
  var service = SearchServiceMock();

  // stubbing
  when(service.completedListing).thenReturn(List());
  when(service.activeListing).thenReturn(List());
  when(service.completedListingAveragePrice).thenReturn(100.0);
  when(service.condition).thenReturn('New');
  when(service.searchKeyword).thenReturn('iPhone 6');
  when(service.imagePath).thenReturn('/file/path');

  locator.registerSingleton<SearchService>(service);
  return service;
}

SearchServiceMock getAndRegisterInitialAfterApiSearchServiceMock() {
  _removeRegistrationIfExists<SearchService>();
  var service = SearchServiceMock();

  // stubbing
  when(service.completedListing).thenReturn(List());
  when(service.completedListing.length).thenReturn(0);
  when(service.activeListing).thenReturn(List());
  when(service.activeListing.length).thenReturn(0);
  when(service.completedListingAveragePrice).thenReturn(100.0);

  locator.registerSingleton<SearchService>(service);
  return service;
}


NavigationService getAndRegisterNavigationServiceMock() {
  _removeRegistrationIfExists<NavigationService>();
  var service = NavigationServiceMock();
  locator.registerSingleton<NavigationService>(service);
  return service;
}

DialogService getAndRegisterDialogServiceMock() {
  _removeRegistrationIfExists<DialogService>();
  var service = DialogServiceMock();
  locator.registerSingleton<DialogService>(service);
  return service;
}

void registerSavedServices() {
  getAndRegisterApiMock();
  getAndRegisterSavedSearchServiceMock();
  getAndRegisterNavigationServiceMock();
  getAndRegisterDialogServiceMock();
}

void registerInitialServices() {
  getAndRegisterApiMock();
  getAndRegisterInitialSearchServiceMock();
  getAndRegisterNavigationServiceMock();
  getAndRegisterDialogServiceMock();
}

void registerApiMock() {
  getAndRegisterApiMock();
}

void unregisterServices() {
  locator.unregister<Api>();
  locator.unregister<SearchService>();
  locator.unregister<NavigationService>();
  locator.unregister<DialogService>();
}

void unregisterApiService() {
  locator.unregister<Api>();
}

void _removeRegistrationIfExists<T>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}
