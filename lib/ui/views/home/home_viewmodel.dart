import 'package:priceit/app/locator.dart';
import 'package:priceit/datamodels/item.dart';
import 'package:priceit/services/api.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeViewModel extends FutureViewModel<List<Item>> {
  String conditionValue = 'Used';
  String searchKeyword = 'iphone 6';
  final apiService = locator<Api>();

  void updateSelectorValue(String newValue) {
    conditionValue = newValue;
    notifyListeners();
  }

  void launchUrl(String viewItemURL) async {
    if (await canLaunch(viewItemURL)) {
      await launch(viewItemURL);
    } else {
      throw 'Could not launch $viewItemURL';
    }
  }

  @override
  void onError(error) {
    // TODO: Revisit this
  }

  @override
  Future<List<Item>> futureToRun() {
    return apiService.searchForItems(conditionValue, searchKeyword);
  }
}
