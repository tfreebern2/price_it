import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:priceit/app/router.gr.dart';
import 'package:priceit/ui/views/keywordsearch/home/keywordsearch_viewmodel.dart';

import '../../../setup/test_helpers.dart';

void main() {
  group('KeywordSearchViewModelTest -', () {
    setUp(() => registerInitialServices());
    tearDown(() => unregisterServices());

    test('When search button (from search bar) is tapped, navigate to Completed List View', () async {
      var navigationService = getAndRegisterNavigationServiceMock();
      var model = KeywordSearchViewModel();
      model.navigateToCompleted();
      verify(navigationService.navigateTo(Routes.completedListingView));
    });
  });
}