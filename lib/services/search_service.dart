import 'package:injectable/injectable.dart';
import 'package:observable_ish/observable_ish.dart';
import 'package:priceit/datamodels/item.dart';
import 'package:stacked/stacked.dart';

@lazySingleton
class SearchService with ReactiveServiceMixin {
  RxValue<String> _condition = RxValue<String>(initial: 'Used');
  RxValue<String> _searchKeyword = RxValue<String>(initial: 'iPhone 6');
  RxValue<List<Item>> _completedListing = RxValue<List<Item>>(initial: List<Item>());
  RxValue<List<Item>> _activeListing = RxValue<List<Item>>(initial: List<Item>());
  RxValue<double> _completedListingAveragePrice = RxValue<double>(initial: 0.00);
  RxValue<double> _completedListingPercentageSold = RxValue<double>(initial: 0.00);
  RxValue<double> _activeListingAveragePrice = RxValue<double>(initial: 0.00);
  RxValue<String> _productType = RxValue<String>(initial: 'UPC');
  RxValue<String> _productId = RxValue<String>(initial: '0');
  RxValue<String> _imagePath = RxValue<String>(initial: null);

  SearchService() {
    listenToReactiveValues([
      _condition,
      _searchKeyword,
      _completedListing,
      _activeListing,
      _productType,
      _productId,
      _imagePath
    ]);
  }

  String get condition => _condition.value;
  String get searchKeyword => _searchKeyword.value;
  List<Item> get completedListing => _completedListing.value;
  List<Item> get activeListing => _activeListing.value;
  double get completedListingAveragePrice => _completedListingAveragePrice.value;
  double get completedListingPercentageSold => _completedListingPercentageSold.value;
  double get activeListingAveragePrice => _activeListingAveragePrice.value;
  String get productType => _productType.value;
  String get productId => _productId.value;
  String get imagePath => _imagePath.value;

  void updateCondition(String newValue) {
    _condition.value = newValue;
  }

  void updateSearchKeyword(String newValue) {
    _searchKeyword.value = newValue;
  }

  void setCompletedListingAveragePrice(double newValue) {
    _completedListingAveragePrice.value = newValue;
  }

  void setCompletedListingPercentageSold(double newValue) {
    _completedListingPercentageSold.value = newValue;
  }

  void setActiveListingAveragePrice(double newValue) {
    _activeListingAveragePrice.value = newValue;
  }

  void updateCompletedAndActiveListings(Future<List<Item>> completedListings, Future<List<Item>> activeListings) async {
    await completedListings.asStream().forEach((futureList) {
      futureList.forEach((futureItem) {
        _completedListing.value.add(futureItem);
      });
    });

    await activeListings.asStream().forEach((futureList) {
      futureList.forEach((futureItem) {
        _activeListing.value.add(futureItem);
      });
    });
  }

  void setProductType(String newValue) {
    _productType.value = newValue;
  }

  void setProductId(String newValue) {
    _productId.value = newValue;
  }

  void updateImagePath(String newValue) {
    _imagePath.value = newValue;
  }

  void resetSearchResultState() {
    _completedListing.value = new List<Item>();
    _activeListing.value = new List<Item>();
    _condition.value = 'Used';
    _completedListingAveragePrice.value = 0.0;
    _completedListingPercentageSold.value = 0.0;
    _activeListingAveragePrice.value = 0.0;
  }
}