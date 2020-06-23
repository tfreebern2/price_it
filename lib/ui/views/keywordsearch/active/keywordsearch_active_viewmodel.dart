import 'package:priceit/app/locator.dart';
import 'package:priceit/app/router.gr.dart';
import 'package:priceit/services/search_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:url_launcher/url_launcher.dart';

class KeywordSearchActiveViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final searchService = locator<SearchService>();

  void launchUrl(String viewItemURL) async {
    if (await canLaunch(viewItemURL)) {
      await launch(viewItemURL);
    } else {
      throw 'Could not launch $viewItemURL';
    }
  }

  void navigateToHome() {
    searchService.resetSearchResultState();
    _navigationService.clearStackAndShow(Routes.keywordSearchHomeView);
  }

  void navigateToComplete() {
    _navigationService.navigateTo(Routes.keywordSearchCompletedView);
  }
}