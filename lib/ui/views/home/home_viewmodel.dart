import 'package:resalechecker/app/locator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends BaseViewModel {
  String _selectorValue = 'Used';
  String get selectorValue => _selectorValue;

  void updateSelectorValue(String newValue) {
    _selectorValue = newValue;
    notifyListeners();
  }
}