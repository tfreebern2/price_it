import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/cupertino.dart';
import 'package:priceit/app/locator.dart';
import 'package:priceit/app/router.gr.dart';
import 'package:priceit/datamodels/image_response.dart';
import 'package:priceit/services/search_service.dart';
import 'package:priceit/util/constants.dart';
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

  void resetSearchService() {
    searchService.setSearchKeyword(notAvailable);
    searchService.setProductType(notAvailable);
  }

  void navigateBack() {
    _navigationService.clearTillFirstAndShow(Routes.productSearchHomeView);
  }

  void navigateToCompleted() {
    _navigationService.navigateTo(Routes.completedListingView);
  }

  Future<void> _initializeVision() async {
    resetSearchService();
    setImageFile(searchService.imagePath);

    if (imageFile != null) {
      setImageSize(await _getImageSize(imageFile));
    }

    FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(imageFile);
    BarcodeDetector barcodeDetector = FirebaseVision.instance.barcodeDetector();
    List barCodes = await barcodeDetector.detectInImage(visionImage);

    for (Barcode readableCode in barCodes) {
      switch (readableCode.valueType) {
        case BarcodeValueType.product:
          searchService.setSearchKeyword(readableCode.displayValue);
          searchService.setProductType(upc);
          break;
        case BarcodeValueType.isbn:
          searchService.setSearchKeyword(readableCode.displayValue);
          searchService.setProductType(isbn);
          break;
        default:
          searchService.setSearchKeyword(notAvailable);
          searchService.setProductType(notAvailable);
          break;
      }
    }
    barcodeDetector.close();
  }

  Future<Size> _getImageSize(File imageFile) async {
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
    return imageSize;
  }

  Future<ImageResponse> buildImageResponse(
      File imageFile, Size imageSize, String searchKeyword, String productType) async {
    ImageResponse imageResponse =
        new ImageResponse.build(imageFile, imageSize, searchKeyword, productType);
    return imageResponse;
  }

  @override
  Future<ImageResponse> futureToRun() async {
    await _initializeVision();
    return await buildImageResponse(
        imageFile, imageSize, searchService.searchKeyword, searchService.productType);
  }
}