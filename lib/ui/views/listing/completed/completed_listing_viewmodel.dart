import 'package:priceit/app/locator.dart';
import 'package:priceit/app/router.gr.dart';
import 'package:priceit/datamodels/ebay_response.dart';
import 'package:priceit/datamodels/item.dart';
import 'package:priceit/services/api.dart';
import 'package:priceit/services/search_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:url_launcher/url_launcher.dart';

class CompletedListingViewModel extends FutureViewModel<EbayResponse> {
  final _navigationService = locator<NavigationService>();
  final _apiService = locator<Api>();
  final searchService = locator<SearchService>();

  double completedListingAveragePrice = 0.00;
  double completedListingPercentageSold = 0.00;
  double activeListingAveragePrice = 0.00;
  int totalEntries = 0;

  void navigateToHome() {
    searchService.resetSearchResultState();
    _navigationService.clearStackAndShow(Routes.selectionView);
  }

  void navigateToActive() {
    _navigationService.navigateTo(Routes.activeListingView);
  }

  void launchUrl(String viewItemURL) async {
    if (await canLaunch(viewItemURL)) {
      await launch(viewItemURL);
    } else {
      throw 'Could not launch $viewItemURL';
    }
  }

  bool checkIfSavedApiCall() {
    if (searchService.completedListing.isNotEmpty) {
      return true;
    }
    return false;
  }

  void setSearchServiceValues(double completedListingAveragePrice,
      double completedListingPercentageSold, double activeListingAveragePrice) {
    searchService.setCompletedListingAveragePrice(completedListingAveragePrice);
    searchService.setCompletedListingPercentageSold(completedListingPercentageSold);
    searchService.setActiveListingAveragePrice(activeListingAveragePrice);
  }

  void calculateSaleThroughRateAndAveragePrice(
      List<Item> completedListings, List<Item> activeListings) {
    int completedListLength = 0;
    int activeListLength = 0;
    double completedSoldAmount = 0.00;
    int completedTotalEntries = 0;
    int activeTotalEntries = 0;
    double activeSoldAmount = 0.00;

    if (completedListings.length > 0) {
      completedTotalEntries = int.parse(completedListings.first.totalEntries);
      completedListings.forEach((item) {
        completedSoldAmount += double.parse(item.currentPrice.replaceAll("\$", ""));
        completedListLength += 1;
      });
    }

    if (activeListings.length > 0) {
      activeTotalEntries = int.parse(activeListings.first.totalEntries);
      activeListings.forEach((item) {
        activeSoldAmount += double.parse(item.currentPrice.replaceAll("\$", ""));
        activeListLength += 1;
      });
    }

    completedListingAveragePrice = completedSoldAmount / completedListLength;
    totalEntries = completedTotalEntries + activeTotalEntries;
    completedListingPercentageSold = (completedTotalEntries / totalEntries) * 100;
    activeListingAveragePrice = activeSoldAmount / activeListLength;
    setSearchServiceValues(
        completedListingAveragePrice, completedListingPercentageSold, activeListingAveragePrice);
  }

  Future<EbayResponse> buildInitialEbayResponse(
      List<Item> completedListings, List<Item> activeListings) async {
    searchService.setCompletedAndActiveListings(completedListings, activeListings);
    EbayResponse ebayResponse = new EbayResponse.build(completedListings, activeListings,
        completedListingAveragePrice, completedListingPercentageSold, activeListingAveragePrice);
    return ebayResponse;
  }

  Future<EbayResponse> buildSavedEbayResponse() async {
    EbayResponse ebayResponse = new EbayResponse.build(
        searchService.completedListing,
        searchService.activeListing,
        searchService.completedListingAveragePrice,
        searchService.completedListingPercentageSold,
        searchService.activeListingAveragePrice);
    return ebayResponse;
  }

  @override
  void onError(error) {
    // TODO: Revisit this
  }

  @override
  Future<EbayResponse> futureToRun() async {
    if (checkIfSavedApiCall()) {
      return await buildSavedEbayResponse();
    } else {
//      if (searchService.condition == newValue) {
//        // Completed Items
//        Future<List<Item>> newCompletedItemsResponse = _apiService.searchForCompletedItems(newValue, searchService.searchKeyword);
//        Future<List<Item>> newOrOtherCompletedItemsResponse = _apiService.searchForCompletedItems(newOrOtherValue, searchService.searchKeyword);
//        // Active Items
//        Future<List<Item>> newActiveItemsResponse = _apiService.searchForActiveItems(newValue, searchService.searchKeyword);
//        Future<List<Item>> newOrOtherActiveItemsResponse = _apiService.searchForActiveItems(newOrOtherValue, searchService.searchKeyword);
//        // Calculate Sales Through Rate
//        // build Initial Response
//      } else {
//        // Completed Items
//        Future<List<Item>> usedCompletedItemsResponse = _apiService.searchForCompletedItems(usedValue, searchService.searchKeyword);
//        Future<List<Item>> veryGoodCompletedItemsResponse = _apiService.searchForCompletedItems(veryGoodValue, searchService.searchKeyword);
//        Future<List<Item>> goodCompletedItemsResponse = _apiService.searchForCompletedItems(goodValue, searchService.searchKeyword);
//        Future<List<Item>> acceptableCompletedItemsResponse = _apiService.searchForCompletedItems(acceptableValue, searchService.searchKeyword);
//        // Active Items
//        Future<List<Item>> usedActiveItemsResponse = _apiService.searchForActiveItems(usedValue, searchService.searchKeyword);
//        Future<List<Item>> veryGoodActiveItemsResponse = _apiService.searchForActiveItems(veryGoodValue, searchService.searchKeyword);
//        Future<List<Item>> goodActiveItemsResponse = _apiService.searchForActiveItems(goodValue, searchService.searchKeyword);
//        Future<List<Item>> acceptableActiveItemsResponse = _apiService.searchForActiveItems(acceptableValue, searchService.searchKeyword);
//        // Calculate Sales Through Rate
//        // build Initial Response
//      }
      List<Item> completedItemsResponse = await _apiService.searchForCompletedItems(
          searchService.condition, searchService.searchKeyword);
      List<Item> activeItemsResponse = await _apiService.searchForActiveItems(
          searchService.condition, searchService.searchKeyword);
      calculateSaleThroughRateAndAveragePrice(completedItemsResponse, activeItemsResponse);
      return await buildInitialEbayResponse(completedItemsResponse, activeItemsResponse);
    }
  }
}
