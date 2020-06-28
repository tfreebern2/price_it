import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/cupertino.dart';
import 'package:priceit/app/locator.dart';
import 'package:priceit/app/router.gr.dart';
import 'package:priceit/datamodels/image_response.dart';
import 'package:priceit/services/search_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ProductSearchPhotoDetailViewModel extends FutureViewModel<ImageResponse> {
  final _navigationService = locator<NavigationService>();
  final searchService = locator<SearchService>();
  File imageFile;
  Size imageSize;
  List<TextElement> elements = [];

  void setImageFile(String path) {
    imageFile = File(searchService.imagePath);
  }

  void setImageSize(Size newSize) {
    imageSize = newSize;
  }

  void navigateBack() {
    _navigationService.clearStackAndShow(Routes.selectionView);
  }

  void navigateToCompleted() {
    _navigationService.navigateTo(Routes.keywordSearchCompletedView);
  }

  Future<void> _initializeVision() async {
    setImageFile(searchService.imagePath);

    if (imageFile != null) {
      await _getImageSize(imageFile);
    }

    FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(imageFile);
    BarcodeDetector barcodeDetector = FirebaseVision.instance.barcodeDetector();
    List barCodes = await barcodeDetector.detectInImage(visionImage);

    for (Barcode readableCode in barCodes) {
      if (readableCode.format.value == -1 ) {
        searchService.setProductId("Unknown Value");
        searchService.setProductType("Unknown Value");
        return;
      }
      switch (readableCode.valueType) {
        case BarcodeValueType.product:
          searchService.setProductId(readableCode.displayValue);
          searchService.setProductType('UPC');
          break;
        case BarcodeValueType.isbn:
          searchService.setProductId(readableCode.displayValue);
          searchService.setProductType('ISBN');
          break;
        default:
          searchService.setProductId(readableCode.displayValue);
          break;
      }
    }
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
    setImageSize(imageSize);
  }

  Future<ImageResponse> buildImageResponse(File imageFile, Size imageSize, String productId, String productType) async {
    ImageResponse imageResponse = new ImageResponse.build(imageFile, imageSize, searchService.productId, searchService.productType);
    return imageResponse;
  }


  @override
  Future<ImageResponse> futureToRun() async {
    await _initializeVision();
    return await buildImageResponse(imageFile, imageSize, searchService.productId, searchService.productType);
  }
}