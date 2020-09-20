import 'dart:io';

import 'package:priceit/app/locator.dart';
import 'package:priceit/app/router.gr.dart';
import 'package:priceit/datamodels/ebay_response.dart';
import 'package:priceit/datamodels/item.dart';
import 'package:priceit/datamodels/search_criteria.dart';
import 'package:priceit/services/api.dart';
import 'package:priceit/services/search_service.dart';
import 'package:priceit/util/constants.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:url_launcher/url_launcher.dart';

class CompletedListingViewModel extends FutureViewModel<EbayResponse> {
  final navigationService = locator<NavigationService>();
  final _apiService = locator<Api>();
  final _dialogService = locator<DialogService>();
  final searchService = locator<SearchService>();

  // TODO: Turn into Private Variables
  double completedListingAveragePrice = 0.00;
  double completedListingPercentageSold = 0.00;
  double activeListingAveragePrice = 0.00;
  int completedListLength = 0;
  int activeListLength = 0;
  double completedSoldAmount = 0.00;
  int completedTotalEntries = 0;
  int activeTotalEntries = 0;
  double activeSoldAmount = 0.00;
  int totalEntries = 0;

  void navigateToSelectionView() {
    searchService.resetSearchResultState();
    navigationService.clearStackAndShow(Routes.selectionView);
  }

  void navigateToActiveListingView() {
    navigationService.navigateTo(Routes.activeListingView);
  }

  void launchUrl(String viewItemURL) async {
    if (await canLaunch(viewItemURL)) {
      await launch(viewItemURL);
    } else {
      throw 'Could not launch $viewItemURL';
    }
  }

  bool checkIfSavedApiCall() {
    if (searchService.apiCalled == true && searchService.apiError == false) {
      return true;
    } else if (searchService.apiError) {
      throw Exception("Api Error from original request");
    }
    return false;
  }

  void setSearchServiceValues(double completedListingAveragePrice,
      double completedListingPercentageSold, double activeListingAveragePrice) {
    searchService.setCompletedListingAveragePrice(completedListingAveragePrice);
    searchService.setCompletedListingPercentageSold(completedListingPercentageSold);
    searchService.setActiveListingAveragePrice(activeListingAveragePrice);
  }

  void calculateSaleThroughRateAndAveragePrice(List<Item> completedListings, List<Item> activeListings) {
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
    setSearchServiceValues(completedListingAveragePrice, completedListingPercentageSold, activeListingAveragePrice);
  }

  Future<EbayResponse> buildInitialEbayResponse(List<Item> completedListings, List<Item> activeListings) async {
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

  Future showDialog() async {
    await _dialogService.showDialog(
        title: 'Something went wrong!',
        description: 'Please try searching again.',
        buttonTitle: 'Ok',
        dialogPlatform: Platform.isIOS ? DialogPlatform.Cupertino : DialogPlatform.Material);
  }

  @override
  void onError(error) {
    searchService.setApiError(true);
    showDialog();
  }

  @override
  Future<EbayResponse> futureToRun() async {
    if (checkIfSavedApiCall()) {
      return await buildSavedEbayResponse();
    } else {
      if (searchService.condition == newValue) {
        List<Item> completedListings = await _apiService.searchForCompletedItems(newValue, searchService.searchKeyword, searchService.region);
        List<Item> activeListings = await _apiService.searchForActiveItems(newValue, searchService.searchKeyword);
        searchService.setApiCalled(true);
        calculateSaleThroughRateAndAveragePrice(completedListings, activeListings);
        return await buildInitialEbayResponse(completedListings, activeListings);
      } else {
        List<Item> completedListings = await _apiService.searchForCompletedItems(usedValue, searchService.searchKeyword, searchService.region);
        List<Item> activeListings = await _apiService.searchForActiveItems(usedValue, searchService.searchKeyword);
        searchService.setApiCalled(true);
        calculateSaleThroughRateAndAveragePrice(completedListings, activeListings);
        return await buildInitialEbayResponse(completedListings, activeListings);
      }
    }
  }
}
