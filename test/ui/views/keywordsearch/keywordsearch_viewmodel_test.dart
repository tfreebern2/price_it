import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:priceit/app/router.gr.dart';
import 'package:priceit/ui/views/keywordsearch/home/keywordsearch_viewmodel.dart';

import '../../../setup/test_helpers.dart';

void main() {
  group('KeywordSearchViewModelTest -', () {
    setUp(() => registerInitialServices());
    tearDown(() => unregisterServices());

    test('When search button (from search bar) is tapped, navigate to Active List View', () async {
      var navigationService = getAndRegisterNavigationServiceMock();
      var model = KeywordSearchViewModel();
      model.navigateToActiveListing();
      verify(navigationService.navigateTo(Routes.activeListingView));
    });
  });
}