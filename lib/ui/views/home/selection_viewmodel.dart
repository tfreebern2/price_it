import 'package:priceit/app/locator.dart';
import 'package:priceit/app/router.gr.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SelectionViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  void navigateToKeyword() {
    _navigationService.navigateTo(Routes.keywordSearchView);
  }

  void navigateToProduct() {
    _navigationService.navigateTo(Routes.productSearchHomeView);
  }
}