import 'package:priceit/app/locator.dart';
import 'package:priceit/app/router.gr.dart';
import 'package:priceit/services/search_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:url_launcher/url_launcher.dart';

class ActiveListingViewModel extends BaseViewModel {
  final navigationService = locator<NavigationService>();
  final dialogService = locator<DialogService>();
  final searchService = locator<SearchService>();

  void launchUrl(String viewItemURL) async {
    if (await canLaunch(viewItemURL)) {
      await launch(viewItemURL);
    } else {
      throw 'Could not launch $viewItemURL';
    }
  }

  void navigateToSelectionView() {
    searchService.resetSearchResultState();
    navigationService.clearStackAndShow(Routes.selectionView);
  }

  void navigateToCompletedListingView() {
    navigationService.navigateTo(Routes.completedListingView);
  }
}