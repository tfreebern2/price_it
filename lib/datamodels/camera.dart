import 'dart:io';

import 'package:camera/camera.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class Camera {
  CameraController _cameraController;

  Camera(this._cameraController);

  CameraController get cameraController => _cameraController;

  void setCamera(CameraController controller) {
    _cameraController = controller;
  }

  Camera.build(CameraController controller) {
    setCamera(controller);
  }

  Future<String> takePicture() async {
    if (!_cameraController.value.isInitialized) {
      print("Controller not initialized");
      return null;
    }

    String dateTime = DateFormat.yMMMd().addPattern('-').add_Hms().format(DateTime.now()).toString();

    String formattedDateTime = dateTime.replaceAll(' ', '');

    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String visionDir = '${appDocDir.path}/Photos/Vision\ Images';
    await Directory(visionDir).create(recursive: true);
    final String imagePath = '$visionDir/image_$formattedDateTime.jpg';

    if (_cameraController.value.isTakingPicture) {
      print("Processing is progress ...");
      return null;
    }

    try {
      await _cameraController.takePicture(imagePath);
    } on CameraException catch (e) {
      print("Camera Exception: $e");
      return null;
    }

    return imagePath;
  }
}