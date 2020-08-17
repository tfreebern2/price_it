import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:priceit/app/router.gr.dart';
import 'package:priceit/ui/views/productsearch/photodetail/productsearch_photodetail_viewmodel.dart';

import '../../../../setup/test_helpers.dart';

void main() {
  group('ProductSearchHomeViewModelTest -', () {
    setUp(() => registerInitialServices());
    tearDown(() => unregisterServices());

    test('Pass new file path and set File for view', () async {
      var model = ProductSearchPhotoDetailViewModel();
      model.initialise();
      model.setImageFile('/file/path');
      expect(model.imageFile.path, '/file/path');
    });

    test('Pass size to set Image Size for view', () async {
      var model = ProductSearchPhotoDetailViewModel();
      model.initialise();
      Size fileSize = new Size(1.00, 1.00);
      model.setImageSize(fileSize);
      expect(model.imageSize.width, 1.00);
    });

    test('Reset Search Service Keyword and Product Type to Not Available', () async {
    });

    test('When user taps Back button clear till first and show ProductSearchHomeView', () async {
      var navigationService = getAndRegisterNavigationServiceMock();
      var model = ProductSearchPhotoDetailViewModel();
      model.initialise();
      model.navigateBack();
      verify(navigationService.clearTillFirstAndShow(Routes.productSearchHomeView));
    });

    test('When user taps Search button navigate to CompletedListingView', () async {
      var navigationService = getAndRegisterNavigationServiceMock();
      var model = ProductSearchPhotoDetailViewModel();
      model.initialise();
      model.navigateToCompleted();
      verify(navigationService.navigateTo(Routes.completedListingView));
    });

    test('When barcode type is ISBN set product type to isbn', () async {
    });

    test('Get image size returns successfully', () async {
    });
  });
}