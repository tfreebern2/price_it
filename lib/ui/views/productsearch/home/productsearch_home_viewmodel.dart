import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:priceit/app/locator.dart';
import 'package:priceit/app/router.gr.dart';
import 'package:priceit/datamodels/camera.dart';
import 'package:priceit/services/search_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ProductSearchHomeViewModel extends FutureViewModel<Camera> {
  final _navigationService = locator<NavigationService>();
  final _searchService = locator<SearchService>();
  final _dialogService = locator<DialogService>();

  List<CameraDescription> cameras = [];
  Camera camera;

  String get condition => _searchService.condition;
  String get searchKeyword => _searchService.searchKeyword;
  String get region => _searchService.region;

  PermissionStatus cameraStatus;
  PermissionStatus microphoneStatus;
  PermissionStatus storageStatus;

  void navigateToPhotoDetail() {
    camera.cameraController.dispose();
    _navigationService.navigateTo(Routes.productSearchPhotoDetailView);
  }

  void navigateToHome() {
    camera.cameraController.dispose();
    _searchService.resetSearchResultState();
    _navigationService.clearStackAndShow(Routes.selectionView);
  }

  void navigateToHomeIfCameraDenied() {
    _searchService.resetSearchResultState();
    _navigationService.clearStackAndShow(Routes.selectionView);
  }

  void updateCondition(String newValue) {
    _searchService.setCondition(newValue);
    notifyListeners();
  }

  void updateRegion(String newValue) {
    _searchService.setRegion(newValue);
    notifyListeners();
  }

  void updateImagePath(String newValue) {
    _searchService.setImagePath(newValue);
    notifyListeners();
  }

  Future checkCameraPermissionStatus() async {
    return await Permission.camera.status;
  }

  Future checkMicrophonePermissionStatus() async {
    return await Permission.microphone.status;
  }

  Future checkStoragePermissionStatus() async {
    return await Permission.storage.status;
  }

  Future requestPermissions() async {
    if (cameraStatus.isUndetermined) {
      await Permission.camera.request();
    }

    if (microphoneStatus.isUndetermined) {
      await Permission.microphone.request();
    }

    if (storageStatus.isUndetermined) {
      await Permission.storage.request();
    }
  }

  Future showIOSPermissionDialog() async {
    await _dialogService.showDialog(
        title: 'Insufficient Privileges',
        description: 'In order to use the scan feature, please allow camera and microphone access.',
        buttonTitle: 'Ok',
        dialogPlatform: Platform.isIOS ? DialogPlatform.Cupertino : DialogPlatform.Material);
  }

  Future showAndroidPermissionDialog() async {
    await _dialogService.showDialog(
        title: 'Insufficient Privileges',
        description: 'In order to use the scan feature, please allow camera, microphone and storage access.',
        buttonTitle: 'Ok',
        dialogPlatform: Platform.isIOS ? DialogPlatform.Cupertino : DialogPlatform.Material);
  }

  Future showDialog() async {
    await _dialogService.showDialog(
        title: 'Something went wrong!',
        description: 'Please try again.',
        buttonTitle: 'Ok',
        dialogPlatform: Platform.isIOS ? DialogPlatform.Cupertino : DialogPlatform.Material);
  }

  @override
  void onError(error) {
    showDialog();
  }

  @override
  Future<Camera> futureToRun() async {
    cameraStatus = await checkCameraPermissionStatus();
    microphoneStatus = await checkMicrophonePermissionStatus();
    storageStatus = await checkStoragePermissionStatus();

    await requestPermissions();

    cameraStatus = await checkCameraPermissionStatus();
    microphoneStatus = await checkMicrophonePermissionStatus();
    storageStatus = await checkStoragePermissionStatus();

    if (cameraStatus.isDenied ||
        cameraStatus.isPermanentlyDenied ||
        microphoneStatus.isDenied ||
        microphoneStatus.isPermanentlyDenied ||
        storageStatus.isDenied ||
        storageStatus.isPermanentlyDenied) {
      if (Platform.isIOS) {
        await showIOSPermissionDialog();
      } else if (Platform.isAndroid) {
        await showAndroidPermissionDialog();
      }
      openAppSettings();
      navigateToHomeIfCameraDenied();
      return null; // stops app from trying to retrieve camera
    }

    try {
      WidgetsFlutterBinding.ensureInitialized();
      cameras = await availableCameras();
    } on CameraException catch (e) {
      print(e);
    }

    camera = new Camera.build(CameraController(cameras[0], ResolutionPreset.ultraHigh));
    await camera.cameraController.initialize();
    // check if you need to mount camera
    return camera;
  }
}