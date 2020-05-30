import 'package:priceit/app/locator.dart';
import 'package:priceit/datamodels/item.dart';
import 'package:priceit/services/api.dart';
import 'package:stacked/stacked.dart';

class HomeViewModel extends FutureViewModel<List<Item>> {
  String selectorValue = 'Used';
  String searchText = 'iphone 6';
  final apiService = locator<Api>();
  Future<List<Item>> itemList;

  void updateSelectorValue(String newValue) {
    selectorValue = newValue;
    notifyListeners();
  }

  @override
  Future<List<Item>> futureToRun() {
    return apiService.searchForItems(searchText);
  }
}