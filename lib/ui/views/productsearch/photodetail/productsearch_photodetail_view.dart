import 'package:flutter/material.dart';
import 'package:priceit/ui/views/productsearch/photodetail/productsearch_photodetail_viewmodel.dart';
import 'package:priceit/ui/widgets/widgets.dart';
import 'package:stacked/stacked.dart';
import 'dart:ui';

class ProductSearchPhotoDetailView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProductSearchPhotoDetailViewModel>.reactive(
        builder: (context, model, child) => Scaffold(
            appBar: customAppbar(),
            body: WillPopScope(
              onWillPop: () => onBack(model),
              child: model.isBusy
                  ? Container(child: Center(child: CircularProgressIndicator()))
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
                          child: Card(
                            elevation: 8,
                            color: Theme.of(context).backgroundColor,
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
                                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    height: 60,
                                    child: SingleChildScrollView(
                                      child: Text(
                                        model.data.searchKeyword,
                                        style: TextStyle(fontSize: 26.0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: RaisedButton.icon(
                              onPressed: () => onBack(model),
                              icon: Icon(Icons.arrow_back),
                              label: Text('Back'),
                              color: Theme.of(context).accentColor,
                              shape: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: RaisedButton.icon(
                              onPressed: () => model.navigateToCompleted(),
                              icon: Icon(Icons.arrow_forward),
                              label: Text('Search'),
                              color: Theme.of(context).accentColor,
                              shape: OutlineInputBorder(),
                            ),
                          ),
                        )
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