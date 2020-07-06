import 'dart:io';

import 'package:flutter/material.dart';

class ImageResponse {
  File _imageFile;
  Size _imageSize;
  String _searchKeyword;
  String _productType;

  ImageResponse(this._imageFile, this._imageSize, this._searchKeyword, this._productType);

  File get imageFile => _imageFile;
  Size get imageSize => _imageSize;
  String get searchKeyword => _searchKeyword;
  String get productType => _productType;

  void setImageFile(File imageFile) {
    _imageFile = imageFile;
  }

  void setImageSize(Size newValue) {
    _imageSize = newValue;
  }

  void setSearchKeyword(String newValue) {
    _searchKeyword = newValue;
  }

  void setProductType(String newValue) {
    _productType = newValue;
  }

  ImageResponse.build(File imageFile, Size size, String productId, String productType) {
    setImageFile(imageFile);
    setImageSize(size);
    setSearchKeyword(productId);
    setProductType(productType);
  }
}