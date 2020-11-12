import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:priceit/ui/views/productsearch/photodetail/productsearch_photodetail_viewmodel.dart';
import 'package:priceit/util/constants.dart';
import 'package:stacked/stacked.dart';
import 'dart:ui';

class ProductSearchPhotoDetailView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProductSearchPhotoDetailViewModel>.reactive(
        builder: (context, model, child) => Scaffold(
            appBar: _appBar(context, model),
            body: WillPopScope(
              onWillPop: () => onBack(model),
              child: model.isBusy
                  ? Container(
                      child: Center(
                          child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(standardPurple))))
                  : Stack(
                      children: <Widget>[
                        Center(
                          child: Container(
                              width: double.maxFinite,
                              color: Colors.black,
                              child: AspectRatio(
                                  aspectRatio: model.data.imageSize.aspectRatio,
                                  child: Image.file(model.data.imageFile))),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Card(
                              elevation: 8,
                              color: standardPurple,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0),
                                      child: Text(
                                        "Identified " + model.data.productType,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      height: 60,
                                      child: SingleChildScrollView(
                                        child: Text(
                                          model.data.searchKeyword,
                                          style: TextStyle(color: Colors.white, fontSize: 26.0),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        searchButton(context, model)
                      ],
                    ),
            )),
        viewModelBuilder: () => ProductSearchPhotoDetailViewModel());
  }
}

Future<bool> onBack(model) async {
  model.searchService.resetSearchResultState();
  model.navigateBack();
  return true;
}

Widget _appBar(context, model) {
  return Platform.isIOS
      ? CupertinoNavigationBar(
    actionsForegroundColor: Colors.white,
    backgroundColor: standardGreen,
    middle: Text(
      'Price It!',
      style: TextStyle(
          fontFamily: 'Oswald',
          color: Colors.white,
          fontSize: 22.0,
          fontWeight: FontWeight.w600),
    ),
  )
      : AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: standardGreen,
    title: Text(
      'Price It!',
      style: TextStyle(
          fontFamily: 'Oswald',
          color: Colors.white,
          fontSize: 22.0,
          fontWeight: FontWeight.w600),
    ),
  );
}

Widget searchButton(context, model) {
  if (model.searchService.searchKeyword == notAvailable) {
    return Container();
  } else {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: RaisedButton.icon(
          onPressed: () => model.navigateToActive(),
          icon: Icon(Icons.search, color: Colors.white),
          label: Text('Search', style: TextStyle(color: Colors.white)),
          color: standardGreen,
          shape: OutlineInputBorder(),
        ),
      ),
    );
  }
}
