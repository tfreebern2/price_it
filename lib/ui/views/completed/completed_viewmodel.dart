import 'package:priceit/app/locator.dart';
import 'package:priceit/app/router.gr.dart';
import 'package:priceit/datamodels/ebay_response.dart';
import 'package:priceit/datamodels/item.dart';
import 'package:priceit/services/api.dart';
import 'package:priceit/services/search_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:url_launcher/url_launcher.dart';

class CompletedViewModel extends FutureViewModel<EbayResponse> {
  final _navigationService = locator<NavigationService>();
  final _apiService = locator<Api>();
  final searchService = locator<SearchService>();

  double completedListingAveragePrice = 0.00;
  double completedListingPercentageSold = 0.00;
  double activeListingAveragePrice = 0.00;

  void navigateToHome() {
    searchService.resetSearchResultState();
    _navigationService.navigateTo(Routes.homeViewRoute);
  }

  void navigateToActive() {
    _navigationService.navigateTo(Routes.activeView);
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

  void calculateSaleThroughRateAndAveragePrice(Future<List<Item>> completedItemList, Future<List<Item>> activeItemList) async {
    int completedListLength = 0;
    int activeListLength = 0;
    double completedSoldAmount = 0.00;
    int completedTotalEntries = 0;
    int activeTotalEntries = 0;
    double activeSoldAmount = 0.00;

    await completedItemList.asStream().forEach((completedItem) {
      completedTotalEntries = int.parse(completedItem.first.totalEntries);
      completedItem.forEach((item) {
        completedSoldAmount += double.parse(item.currentPrice.replaceAll("\$", ""));
        completedListLength += 1;
      });
    });

    await activeItemList.asStream().forEach((activeItem) {
      activeTotalEntries = int.parse(activeItem.first.totalEntries);
      activeItem.forEach((item) {
        activeSoldAmount += double.parse(item.currentPrice.replaceAll("\$", ""));
        activeListLength += 1;
      });
    });

    completedListingAveragePrice = completedSoldAmount / completedListLength;
    int totalEntries = completedTotalEntries + activeTotalEntries;
    completedListingPercentageSold = (completedTotalEntries / totalEntries) * 100;
    activeListingAveragePrice = activeSoldAmount / activeListLength;
    setSearchServiceValues(completedListingAveragePrice, completedListingPercentageSold, activeListingAveragePrice);
  }

  void setSearchServiceValues(double completedListingAveragePrice, double completedListingPercentageSold, double activeListingAveragePrice) {
    searchService.setCompletedListingAveragePrice(completedListingAveragePrice);
    searchService.setCompletedListingPercentageSold(completedListingPercentageSold);
    searchService.setActiveListingAveragePrice(activeListingAveragePrice);
  }

  Future<EbayResponse> buildInitialEbayResponse(Future<List<Item>> completedListings, Future<List<Item>> activeListings) async {
    searchService.updateCompletedAndActiveListings(completedListings, activeListings);
    EbayResponse ebayResponse = new EbayResponse.build(await completedListings, await activeListings,
        completedListingAveragePrice, completedListingPercentageSold, activeListingAveragePrice);
    return ebayResponse;
  }

  Future<EbayResponse> buildSavedEbayResponse(List<Item> completedListings, List<Item> activeListings) async {
    EbayResponse ebayResponse = new EbayResponse.build(searchService.completedListing, searchService.activeListing,
        searchService.completedListingAveragePrice, searchService.completedListingPercentageSold,
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
      return await buildSavedEbayResponse(searchService.completedListing, searchService.activeListing);
    } else {
      Future<List<Item>> completedItemsResponse = _apiService.searchForCompletedItems(searchService.condition, searchService.searchKeyword);
      Future<List<Item>> activeItemsResponse = _apiService.searchForActiveItems(searchService.condition, searchService.searchKeyword);
      calculateSaleThroughRateAndAveragePrice(completedItemsResponse, activeItemsResponse);
      return await buildInitialEbayResponse(completedItemsResponse, activeItemsResponse);
    }
  }
}
