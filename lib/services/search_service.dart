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

  SearchService() {
    listenToReactiveValues([_condition, _searchKeyword, _completedListing, _activeListing]);
  }

  String get condition => _condition.value;
  String get searchKeyword => _searchKeyword.value;
  List<Item> get completedListing => _completedListing.value;
  List<Item> get activeListing => _activeListing.value;

  void updateCondition(String newValue) {
    _condition.value = newValue;
  }

  void updateSearchKeyword(String newValue) {
    _searchKeyword.value = newValue;
  }

  void setCompletedListingToEmpty() {
    _completedListing.value = new List<Item>();
  }

  void setActiveListingToEmpty() {
    _activeListing.value = new List<Item>();
  }

  void updateCompletedListing(Future<List<Item>> completedListings) async {
    await completedListings.asStream().forEach((element) {
      element.forEach((innerElement) {
        _completedListing.value.add(innerElement);
      });
    });
  }

  void updateActiveListing(Future<List<Item>> activeListings) async {
    await activeListings.asStream().forEach((element) {
      element.forEach((innerElement) {
        _activeListing.value.add(innerElement);
      });
    });
  }
}