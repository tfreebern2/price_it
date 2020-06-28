import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:priceit/app/locator.dart';
import 'package:priceit/app/router.gr.dart';
import 'package:priceit/datamodels/camera.dart';
import 'package:priceit/services/search_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ProductSearchHomeViewModel extends FutureViewModel<Camera> {
  List<CameraDescription> cameras = [];
  Camera camera;
  final _navigationService = locator<NavigationService>();
  final _searchService = locator<SearchService>();

  String get condition => _searchService.condition;
  String get searchKeyword => _searchService.searchKeyword;

  void updateCondition(String newValue) {
    _searchService.updateCondition(newValue);
    notifyListeners();
  }

  void updateImagePath(String newValue) {
    _searchService.updateImagePath(newValue);
    notifyListeners();
  }

  void navigateToPhotoDetail() {
    camera.cameraController.dispose();
    _navigationService.navigateTo(Routes.productSearchPhotoDetailView);
  }

  void navigateToHome() {
    camera.cameraController.dispose();
    _searchService.resetSearchResultState();
    _navigationService.clearStackAndShow(Routes.selectionView);
  }

  @override
  Future<Camera> futureToRun() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      cameras = await availableCameras();
    } on CameraException catch (e) {
      print(e);
    }
    camera = new Camera.build(CameraController(cameras[0], ResolutionPreset.high));
    await camera.cameraController.initialize();
    // check if you need to mount camera
    return camera;
  }
}