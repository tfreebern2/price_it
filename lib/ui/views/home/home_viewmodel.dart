import 'package:priceit/app/locator.dart';
import 'package:priceit/datamodels/item.dart';
import 'package:priceit/services/api.dart';
import 'package:stacked/stacked.dart';

class HomeViewModel extends FutureViewModel<List<Item>> {
  String _selectorValue = 'Used';
  String get selectorValue => _selectorValue;
  final _apiService = locator<Api>();

  void updateSelectorValue(String newValue) {
    _selectorValue = newValue;
    notifyListeners();
  }

  @override
  Future<List<Item>> futureToRun() {
    return _apiService.searchForItems();
  }
}