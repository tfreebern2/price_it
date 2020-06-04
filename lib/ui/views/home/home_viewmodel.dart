import 'package:priceit/app/locator.dart';
import 'package:priceit/datamodels/item.dart';
import 'package:priceit/services/api.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeViewModel extends FutureViewModel<List<Item>> {
  String conditionValue = 'Used';
  String searchKeyword = 'iphone 6';

  int completedTotalEntries = 0;
  int activeTotalEntries = 0;
  double completedSoldAmount = 0.00;
  double activeSoldAmount = 0.00;

  double completedListingAveragePrice = 0.00;
  double completedListingPercentageSold = 0.00;
  double activeListingAveragePrice = 0.00;

  List<Item> activeListings = new List<Item>();
  final apiService = locator<Api>();

  void updateSelectorValue(String newValue) {
    conditionValue = newValue;
    notifyListeners();
  }

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

  @override
  void onError(error) {
    // TODO: Revisit this
  }

  @override
  Future<List<Item>> futureToRun() {
    Future<List<Item>> completedItemsResponse =
        apiService.searchForCompletedItems(conditionValue, searchKeyword);
    Future<List<Item>> activeItemsResponse = apiService.searchForActiveItems(conditionValue, searchKeyword);
    calculateSaleThroughRate(completedItemsResponse, activeItemsResponse);
    return completedItemsResponse;
  }
}
