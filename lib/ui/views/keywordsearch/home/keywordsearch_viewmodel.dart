import 'package:priceit/app/locator.dart';
import 'package:priceit/app/router.gr.dart';
import 'package:priceit/services/search_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class KeywordSearchViewModel extends ReactiveViewModel {
  final _searchService = locator<SearchService>();
  final _navigationService = locator<NavigationService>();

  String get condition => _searchService.condition;
  String get searchKeyword => _searchService.searchKeyword;
  String get region => _searchService.region;

  void navigateToActiveListing() {
    _navigationService.navigateTo(Routes.activeListingView);
  }
  void navigateToSelectionView() {
    _navigationService.clearStackAndShow(Routes.selectionView);
  }

  void updateCondition(String newValue) {
    _searchService.setCondition(newValue);
    notifyListeners();
  }

  void updateRegion(String newValue) {
    _searchService.setRegion(newValue);
    notifyListeners();
  }

  void updateSearchKeyword(String newValue) {
    _searchService.setSearchKeyword(newValue);
    _searchService.setSortOrder('Best Match');
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_searchService];
}
