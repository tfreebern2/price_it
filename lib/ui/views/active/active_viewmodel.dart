import 'package:priceit/app/locator.dart';
import 'package:priceit/app/router.gr.dart';
import 'package:priceit/datamodels/item.dart';
import 'package:priceit/services/api.dart';
import 'package:priceit/services/search_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:url_launcher/url_launcher.dart';

class ActiveViewModel extends FutureViewModel<List<Item>> {
  final _apiService = locator<Api>();
  final searchService = locator<SearchService>();
  final _navigationService = locator<NavigationService>();

  String get conditionValue => searchService.condition;
  String get searchKeyword => searchService.searchKeyword;

  int activeTotalEntries = 0;
  double activeSoldAmount = 0.00;
  double activeListingAveragePrice = 0.00;

  void launchUrl(String viewItemURL) async {
    if (await canLaunch(viewItemURL)) {
      await launch(viewItemURL);
    } else {
      throw 'Could not launch $viewItemURL';
    }
  }

  void calculateAveragePrice(Future<List<Item>> activeItemList) async {
    int activeListLength = 0;

    await activeItemList.asStream().forEach((activeItem) {
      activeTotalEntries = int.parse(activeItem.first.totalEntries);
      activeItem.forEach((item) {
        activeSoldAmount += double.parse(item.currentPrice.replaceAll("\$", ""));
        activeListLength += 1;
      });
    });

    activeListingAveragePrice = activeSoldAmount / activeListLength;
  }

  void navigateToHome() {
    searchService.setCompletedListingToEmpty();
    searchService.setActiveListingToEmpty();
    _navigationService.navigateTo(Routes.homeViewRoute);
  }

  void navigateToComplete() {
    _navigationService.navigateTo(Routes.completedView);
  }

  bool checkIfApiCall() {
    if (searchService.activeListing.isNotEmpty) {
      return true;
    }
    return false;
  }

  @override
  Future<List<Item>> futureToRun() {
    if (checkIfApiCall()) {
      return null;
    } else {
      Future<List<Item>> activeItemResponse = _apiService.searchForActiveItems(conditionValue, searchKeyword);
      searchService.updateActiveListing(activeItemResponse);
      calculateAveragePrice(activeItemResponse);
      return activeItemResponse;
    }
  }
}