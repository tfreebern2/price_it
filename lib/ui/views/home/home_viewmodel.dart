import 'package:priceit/app/locator.dart';
import 'package:priceit/app/router.gr.dart';
import 'package:priceit/services/search_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends ReactiveViewModel {
  final _searchService = locator<SearchService>();
  final _navigationService = locator<NavigationService>();

  String get condition => _searchService.condition;
  String get searchKeyword => _searchService.searchKeyword;

  void updateCondition(String newValue) {
    _searchService.updateCondition(newValue);
  }

  void updateSearchKeyword(String newValue) {
    _searchService.updateSearchKeyword(newValue);
  }

  void navigateToCompleted() {
    _navigationService.navigateTo(Routes.completedView);
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_searchService];
}
