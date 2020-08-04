import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:priceit/app/router.gr.dart';
import 'package:priceit/ui/views/home/selection_viewmodel.dart';

import '../../../setup/test_helpers.dart';

void main() {
  group('SelectionViewModelTest -', () {
    setUp(() => registerInitialServices());
    tearDown(() => unregisterServices());

    test('When search button is tapped, clear stack and show Selection View', () async {
      var navigationService = getAndRegisterNavigationServiceMock();
      var model = SelectionViewModel();
      model.navigateToKeyword();
      verify(navigationService.navigateTo(Routes.keywordSearchView));
    });

    test('When completed view listing button is tapped, replace view with Completed View Listing', () async {
      var navigationService = getAndRegisterNavigationServiceMock();
      var model = SelectionViewModel();
      model.navigateToProduct();
      verify(navigationService.navigateTo(Routes.productSearchHomeView));
    });
  });
}