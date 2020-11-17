import 'package:injectable/injectable.dart';
import 'package:observable_ish/observable_ish.dart';
import 'package:priceit/datamodels/item.dart';
import 'package:stacked/stacked.dart';

@lazySingleton
class SearchService with ReactiveServiceMixin {
  RxValue<String> _condition = RxValue<String>(initial: 'Used');
  RxValue<String> _searchKeyword = RxValue<String>(initial: '');
  RxValue<String> _region = RxValue<String>(initial: 'United States');
  RxValue<String> _sortOrder = RxValue<String>(initial: 'Best Match');
  RxValue<List<Item>> _activeListing = RxValue<List<Item>>(initial: List<Item>());
  RxValue<List<Item>> _bestMatchList = RxValue<List<Item>>(initial: List<Item>());
  RxValue<List<Item>> _highPriceList = RxValue<List<Item>>(initial: List<Item>());
  RxValue<List<Item>> _lowPriceList = RxValue<List<Item>>(initial: List<Item>());
  RxValue<double> _activeListingAveragePrice = RxValue<double>(initial: 0.00);
  RxValue<String> _productType = RxValue<String>(initial: '');
  RxValue<String> _imagePath = RxValue<String>(initial: '');

  SearchService() {
    listenToReactiveValues(
        [_condition, _searchKeyword, _region, _sortOrder, _activeListing, _bestMatchList,
          _highPriceList, _lowPriceList, _productType, _imagePath]);
  }

  String get condition => _condition.value;
  String get searchKeyword => _searchKeyword.value;
  String get region => _region.value;
  String get sortOrder => _sortOrder.value;
  List<Item> get activeListing => _activeListing.value;
  List<Item> get bestMatchList => _bestMatchList.value;
  List<Item> get highPriceList => _highPriceList.value;
  List<Item> get lowPriceList => _lowPriceList.value;
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

  void setSortOrder(String newValue) {
    _sortOrder.value = newValue;
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

  void setBestMatchList(List<Item> bestMatchListings) {
    _bestMatchList.value = bestMatchListings;
  }

  void setHighPriceList(List<Item> highPriceListings) {
    _highPriceList.value = highPriceListings;
  }

  void setLowPriceList(List<Item> lowPriceListings) {
    _lowPriceList.value = lowPriceListings;
  }

  void resetSearchResultState() {
    _activeListing.value = new List<Item>();
    _condition.value = 'Used';
    _sortOrder.value = 'Best Match';
    _activeListingAveragePrice.value = 0.0;
  }
}