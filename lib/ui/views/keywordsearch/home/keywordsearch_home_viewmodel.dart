import 'package:priceit/app/locator.dart';
import 'package:priceit/app/router.gr.dart';
import 'package:priceit/services/search_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class KeywordSearchHomeViewModel extends ReactiveViewModel {
  final _searchService = locator<SearchService>();
  final _navigationService = locator<NavigationService>();

  String get condition => _searchService.condition;
  String get searchKeyword => _searchService.searchKeyword;

  void updateCondition(String newValue) {
    _searchService.setCondition(newValue);
  }

  void updateSearchKeyword(String newValue) {
    _searchService.setSearchKeyword(newValue);
  }

  void navigateToCompleted() {
    _navigationService.navigateTo(Routes.completedListingView);
  }

  void navigateToSelectionView() {
    _navigationService.clearStackAndShow(Routes.selectionView);
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_searchService];
}
