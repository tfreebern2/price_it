import 'package:priceit/app/locator.dart';
import 'package:priceit/app/router.gr.dart';
import 'package:priceit/datamodels/item.dart';
import 'package:priceit/services/api.dart';
import 'package:priceit/services/search_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:url_launcher/url_launcher.dart';

class CompletedViewModel extends FutureViewModel<List<Item>> {
  final _apiService = locator<Api>();
  final _searchService = locator<SearchService>();
  final _navigationService = locator<NavigationService>();

  String get conditionValue => _searchService.condition;
  String get searchKeyword => _searchService.searchKeyword;

  int completedTotalEntries = 0;
  int activeTotalEntries = 0;
  double completedSoldAmount = 0.00;
  double activeSoldAmount = 0.00;

  double completedListingAveragePrice = 0.00;
  double completedListingPercentageSold = 0.00;
  double activeListingAveragePrice = 0.00;

  List<Item> activeListings = new List<Item>();

  void launchUrl(String viewItemURL) async {
    if (await canLaunch(viewItemURL)) {
      await launch(viewItemURL);
    } else {
      throw 'Could not launch $viewItemURL';
    }
  }

  void calculateSaleThroughRate(Future<List<Item>> completedItemList, Future<List<Item>> activeItemList) async {
    int completedListLength = 0;
    int activeListLength = 0;
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
    completedListingPercentageSold = ( completedTotalEntries / totalEntries) * 100;
    activeListingAveragePrice = activeSoldAmount / activeListLength;
  }

  void navigateToHome() {
    _navigationService.navigateTo(Routes.homeViewRoute);
  }

  void navigateToActive() {
    _navigationService.navigateTo(Routes.activeView);
  }

  @override
  void onError(error) {
    // TODO: Revisit this
  }

  @override
  Future<List<Item>> futureToRun() {
    Future<List<Item>> completedItemsResponse =
        _apiService.searchForCompletedItems(conditionValue, searchKeyword);
    Future<List<Item>> activeItemsResponse = _apiService.searchForActiveItems(conditionValue, searchKeyword);
    calculateSaleThroughRate(completedItemsResponse, activeItemsResponse);
    return completedItemsResponse;
  }
}
