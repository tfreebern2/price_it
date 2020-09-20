import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:priceit/ui/views/productsearch/home/productsearch_home_viewmodel.dart';
import 'package:priceit/ui/widgets/widgets.dart';
import 'package:priceit/util/constants.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

class ProductSearchHomeView extends StatelessWidget {
  const ProductSearchHomeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProductSearchHomeViewModel>.reactive(
        builder: (context, model, child) => Scaffold(
            appBar: customAppbar(),
            body: model.dataReady
                ? Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      CameraPreview(model.data.cameraController),
                      _regionText(context, model),
                      _RegionSelection(),
                      _conditionText(context, model),
                      _RadioButtons(),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          alignment: Alignment.bottomCenter,
                          child: RaisedButton.icon(
                            onPressed: () async {
                              await model.data.takePicture().then((path) => {
                                    if (path != null) {model.updateImagePath(path)}
                                  });
                              model.navigateToPhotoDetail();
                            },
                            icon: Icon(Icons.camera_alt),
                            label: Text("Scan"),
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      )
                    ],
                  )
                : Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )),
        viewModelBuilder: () => ProductSearchHomeViewModel());
  }
}

Widget _regionText(context, model) {
  return Positioned(
      top: 10,
      child: Text('Select Region: ', style: TextStyle(color: Theme.of(context).accentColor)));
}

class _RegionSelection extends HookViewModelWidget<ProductSearchHomeViewModel> {
  @override
  Widget buildViewModelWidget(BuildContext context, ProductSearchHomeViewModel viewModel) {
    return Positioned(
      top: 30,
      child: DropdownButton<String>(
        value: viewModel.region,
        icon: Icon(Icons.arrow_downward, color: Theme.of(context).accentColor),
        iconSize: 18.0,
        elevation: 16,
        style: TextStyle(fontFamily: 'Oswald', color: Theme.of(context).accentColor, fontSize: 16),
        underline: Container(
          height: 1,
          color: Theme.of(context).accentColor,
        ),
        onChanged: (String newValue) {
          viewModel.updateRegion(newValue);
          debugPrint(viewModel.region);
        },
        items: <String>[
          'Austria',
          'Australia',
          'Switzerland',
          'Germany',
          'Canada (English)',
          'Spain',
          'France',
          'Belgium (French)',
          'Canada (French)',
          'UK',
          'Hong Kong',
          'Ireland',
          'India',
          'Italy',
          'Motors',
          'Malaysia',
          'Netherlands',
          'Belgium (Dutch)',
          'Philippines',
          'Poland',
          'Singapore',
          'United States'
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}

Widget _conditionText(context, model) {
  return Positioned(
      top: 90,
      child: Text('Select Condition: ', style: TextStyle(color: Theme.of(context).accentColor)));
}

class _RadioButtons extends HookViewModelWidget<ProductSearchHomeViewModel> {
  @override
  Widget buildViewModelWidget(BuildContext context, ProductSearchHomeViewModel model) {
    return Positioned(
      top: 100,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Radio(
              value: usedValue,
              groupValue: model.condition.toString(),
              onChanged: (String newValue) {
                model.updateCondition(newValue);
              },
            ),
            Text(usedValue, style: TextStyle(color: Colors.lightGreen, fontSize: 22.0)),
            Radio(
              value: newValue,
              groupValue: model.condition.toString(),
              onChanged: (String newValue) {
                model.updateCondition(newValue);
              },
            ),
            Text(newValue, style: TextStyle(color: Colors.lightGreen, fontSize: 22.0))
          ],
        ),
      ),
    );
  }
}
