import 'dart:io';

import 'package:priceit/app/locator.dart';
import 'package:priceit/app/router.gr.dart';
import 'package:priceit/datamodels/ebay_response.dart';
import 'package:priceit/datamodels/item.dart';
import 'package:priceit/services/api.dart';
import 'package:priceit/services/search_service.dart';
import 'package:priceit/util/constants.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:url_launcher/url_launcher.dart';

class ActiveListingViewModel extends FutureViewModel<EbayResponse> {
  final navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final searchService = locator<SearchService>();
  final _apiService = locator<Api>();

  double _activeListingAveragePrice = 0.00;
  double _activeListingSoldAmount = 0.00;
  int _activeListLength = 0;

  double get activeListingAveragePrice => _activeListingAveragePrice;
  double get activeListingSoldAmount => _activeListingSoldAmount;
  int get activeListLength => _activeListLength;

  void launchUrl(String viewItemURL) async {
    if (await canLaunch(viewItemURL)) {
      await launch(viewItemURL);
    } else {
      throw 'Could not launch $viewItemURL';
    }
  }

  void navigateToSelectionView() {
    searchService.resetSearchResultState();
    navigationService.clearStackAndShow(Routes.selectionView);
  }

  void calculateAveragePrice(List<Item> activeListings) {
    if (activeListings.length > 0) {
      activeListings.forEach((item) {
        _activeListingSoldAmount += double.parse(item.currentPrice.replaceAll("\$", ""));
        _activeListLength += 1;
      });
    }
    _activeListingAveragePrice = (_activeListingSoldAmount / _activeListLength);
  }

  Future<EbayResponse> buildEbayResponse(List<Item> activeListings, double activeListingAveragePrice) async {
    EbayResponse ebayResponse = new EbayResponse.build(activeListings, activeListingAveragePrice);
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
    showDialog();
  }

  @override
  Future<EbayResponse> futureToRun() async {
      if (searchService.condition == newValue) {
        List<Item> activeListings = await _apiService.searchForActiveItems(newValue, searchService.searchKeyword);
        calculateAveragePrice(activeListings);
        return await buildEbayResponse(activeListings, activeListingAveragePrice);
      } else {
        List<Item> activeListings = await _apiService.searchForActiveItems(usedValue, searchService.searchKeyword);
        calculateAveragePrice(activeListings);
        return await buildEbayResponse(activeListings, activeListingAveragePrice);
      }
  }
}