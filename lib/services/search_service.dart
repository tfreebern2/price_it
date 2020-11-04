import 'package:injectable/injectable.dart';
import 'package:observable_ish/observable_ish.dart';
import 'package:priceit/datamodels/item.dart';
import 'package:stacked/stacked.dart';

@lazySingleton
class SearchService with ReactiveServiceMixin {
  RxValue<String> _condition = RxValue<String>(initial: 'Used');
  RxValue<String> _searchKeyword = RxValue<String>(initial: '');
  RxValue<String> _region = RxValue<String>(initial: 'United States');
  RxValue<List<Item>> _activeListing = RxValue<List<Item>>(initial: List<Item>());
  RxValue<double> _activeListingAveragePrice = RxValue<double>(initial: 0.00);
  RxValue<String> _productType = RxValue<String>(initial: '');
  RxValue<String> _imagePath = RxValue<String>(initial: '');

  SearchService() {
    listenToReactiveValues(
        [_condition, _searchKeyword, _region, _activeListing, _productType, _imagePath]);
  }

  String get condition => _condition.value;
  String get searchKeyword => _searchKeyword.value;
  String get region => _region.value;
  List<Item> get activeListing => _activeListing.value;
  double get activeListingAveragePrice => _activeListingAveragePrice.value;
  String get productType => _productType.value;
  String get imagePath => _imagePath.value;

  void setCondition(String newValue) {
    _condition.value = newValue;
  }

  void setSearchKeyword(String newValue) {
    _searchKeyword.value = newValue;
  }

  void setRegion(String newValue) {
    _region.value = newValue;
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

  void setActiveListing(List<Item> activeListings) {
    _activeListing.value = activeListings;
  }

  void resetSearchResultState() {
    _activeListing.value = new List<Item>();
    _condition.value = 'Used';
    _activeListingAveragePrice.value = 0.0;
  }
}