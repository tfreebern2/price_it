import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:priceit/app/router.gr.dart';
import 'package:priceit/ui/views/listing/active/active_listing_viewmodel.dart';

import '../../../../setup/test_helpers.dart';

void main() {
  group('ActiveListingViewModelTest -', () {
    setUp(() => registerInitialServices());
    tearDown(() => unregisterServices());

    test('When search button is tapped, clear stack and show Selection View', () async {
      var navigationService = getAndRegisterNavigationServiceMock();
      var model = ActiveListingViewModel();
      model.navigateToSelectionView();
      verify(navigationService.clearStackAndShow(Routes.selectionView));
    });
  });
}