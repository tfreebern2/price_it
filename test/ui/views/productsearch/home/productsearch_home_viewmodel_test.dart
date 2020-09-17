import 'package:flutter_test/flutter_test.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:priceit/ui/views/productsearch/home/productsearch_home_viewmodel.dart';

import '../../../../setup/test_helpers.dart';

void main() {
  group('ProductSearchHomeViewModelTest -', () {
    setUp(() => registerInitialServices());
    tearDown(() => unregisterServices());

    test('When search button is tapped, clear stack and show Selection View', () async {
      var model = ProductSearchHomeViewModel();
      model.initialise();
    });

    test('When completed view listing button is tapped, replace view with Completed View Listing', () async {
      var model = ProductSearchHomeViewModel();
      model.initialise();
    });

    test('test denied permissions functionality', () async {
      var model = getProductSearchHomeViewModelMockDeniedPermissions();
      model.initialise();
      var cameraPermission = await model.checkCameraPermissionStatus();
      var microphonePermission = await model.checkMicrophonePermissionStatus();
      var storagePermission = await model.checkStoragePermissionStatus();
      expect(cameraPermission, PermissionStatus.denied);
      expect(microphonePermission, PermissionStatus.denied);
      expect(storagePermission, PermissionStatus.denied);
    });

    test('test undetermined permissions functionality', () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      var model = ProductSearchHomeViewModel();
      model.initialise();
      model.cameraStatus = PermissionStatus.undetermined;
    });
  });
}