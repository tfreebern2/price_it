import 'dart:io';

import 'package:flutter/material.dart';

class ImageResponse {
  File _imageFile;
  Size _imageSize;
  String _productId;
  String _productType;

  ImageResponse(this._imageFile, this._imageSize, this._productId, this._productType);

  File get imageFile => _imageFile;
  Size get imageSize => _imageSize;
  String get productId => _productId;
  String get productType => _productType;

  void setImageFile(File imageFile) {
    _imageFile = imageFile;
  }

  void setImageSize(Size newValue) {
    _imageSize = newValue;
  }

  void setProductId(String newValue) {
    _productId = newValue;
  }

  void setProductType(String newValue) {
    _productType = newValue;
  }

  ImageResponse.build(File imageFile, Size size, String productId, String productType) {
    setImageFile(imageFile);
    setImageSize(size);
    setProductId(productId);
    setProductType(productType);
  }
}