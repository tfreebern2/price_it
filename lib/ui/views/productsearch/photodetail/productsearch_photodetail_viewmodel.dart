import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/cupertino.dart';
import 'package:priceit/app/locator.dart';
import 'package:priceit/app/router.gr.dart';
import 'package:priceit/services/search_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ProductSearchPhotoDetailViewModel extends FutureViewModel<void> {
  final _navigationService = locator<NavigationService>();
  final searchService = locator<SearchService>();
  Size _imageSize;
  List<TextElement> _elements = [];

  void navigateBack() {
    _navigationService.back();
  }

  void navigateToCompleted() {
    _navigationService.navigateTo(Routes.keywordSearchCompletedView);
  }

  void _initializeVision() async {
    final File imageFile = File(searchService.imagePath);

    if (imageFile != null) {
      await _getImageSize(imageFile);
    }

    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(imageFile);
    final TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();
    final VisionText visionText = await textRecognizer.processImage(visionImage);

    String pattern = "";
    RegExp regEx = RegExp(pattern);

    String productId = "";
    for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {
        if (regEx.hasMatch(line.text)) {
          productId += line.text + '\n';for (TextElement element in line.elements) {
            _elements.add(element);
          }
        }
      }
    }

    // TODO: Check if camera is mounted
  }

  Future<void> _getImageSize(File imageFile) async {
    final Completer<Size> completer = Completer<Size>();
    final Image image = Image.file(imageFile);

    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ));
      }),
    );

    final Size imageSize = await completer.future;
    _imageSize = imageSize;
  }



  @override
  Future<void> futureToRun() {
    // TODO: implement futureToRun
    throw UnimplementedError();
  }
}