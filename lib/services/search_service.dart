import 'package:injectable/injectable.dart';
import 'package:observable_ish/observable_ish.dart';
import 'package:stacked/stacked.dart';

@lazySingleton
class SearchService with ReactiveServiceMixin {
  RxValue<String> _condition = RxValue<String>(initial: 'Used');
  RxValue<String> _searchKeyword = RxValue<String>(initial: 'iPhone 6');

  SearchService() {
    listenToReactiveValues([_condition, _searchKeyword]);
  }

  String get condition => _condition.value;
  String get searchKeyword => _searchKeyword.value;

  void updateCondition(String newValue) {
    _condition.value = newValue;
  }

  void updateSearchKeyword(String newValue) {
    _searchKeyword.value = newValue;
  }
}