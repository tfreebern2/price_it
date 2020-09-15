import 'package:injectable/injectable.dart';
import 'package:observable_ish/observable_ish.dart';
import 'package:priceit/datamodels/item.dart';
import 'package:stacked/stacked.dart';

@lazySingleton
class SearchService with ReactiveServiceMixin {
  RxValue<bool> _apiCalled = RxValue<bool>(initial: false);
  RxValue<bool> _apiError = RxValue<bool>(initial: false);
  RxValue<String> _condition = RxValue<String>(initial: 'Used');
  RxValue<String> _searchKeyword = RxValue<String>(initial: '');
  RxValue<List<Item>> _completedListing = RxValue<List<Item>>(initial: List<Item>());
  RxValue<List<Item>> _activeListing = RxValue<List<Item>>(initial: List<Item>());
  RxValue<double> _completedListingAveragePrice = RxValue<double>(initial: 0.00);
  RxValue<double> _completedListingPercentageSold = RxValue<double>(initial: 0.00);
  RxValue<double> _activeListingAveragePrice = RxValue<double>(initial: 0.00);
  RxValue<String> _productType = RxValue<String>(initial: '');
  RxValue<String> _imagePath = RxValue<String>(initial: null);

  SearchService() {
    listenToReactiveValues(
        [_apiCalled, _apiError, _condition, _searchKeyword, _completedListing, _activeListing, _productType, _imagePath]);
  }

  bool get apiCalled => _apiCalled.value;
  bool get apiError => _apiError.value;
  String get condition => _condition.value;
  String get searchKeyword => _searchKeyword.value;
  List<Item> get completedListing => _completedListing.value;
  List<Item> get activeListing => _activeListing.value;
  double get completedListingAveragePrice => _completedListingAveragePrice.value;
  double get completedListingPercentageSold => _completedListingPercentageSold.value;
  double get activeListingAveragePrice => _activeListingAveragePrice.value;
  String get productType => _productType.value;
  String get imagePath => _imagePath.value;

  void setApiCalled(bool newValue) {
    _apiCalled.value = newValue;
  }

  void setApiError(bool newValue) {
    _apiError.value = newValue;
  }

  void setCondition(String newValue) {
    _condition.value = newValue;
  }

  void setSearchKeyword(String newValue) {
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

  void setProductType(String newValue) {
    _productType.value = newValue;
  }

  void setImagePath(String newValue) {
    _imagePath.value = newValue;
  }

  void setCompletedAndActiveListings(List<Item> completedListings, List<Item> activeListings) {
    _completedListing.value = completedListings;
    _activeListing.value = activeListings;
  }

  void resetSearchResultState() {
    _apiCalled.value = false;
    _apiError.value = false;
    _completedListing.value = new List<Item>();
    _activeListing.value = new List<Item>();
    _condition.value = 'Used';
    _completedListingAveragePrice.value = 0.0;
    _completedListingPercentageSold.value = 0.0;
    _activeListingAveragePrice.value = 0.0;
  }
}