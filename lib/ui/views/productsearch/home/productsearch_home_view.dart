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
                    children: <Widget>[
                      CameraPreview(model.data.cameraController),
                      _RadioButtons(),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          alignment: Alignment.bottomCenter,
                          child: RaisedButton.icon(
                              onPressed: () async {
                                await model.data.takePicture().then((path) => {
                                      if (path != null) {
                                        model.updateImagePath(path)
                                      }
                                });
                                model.navigateToHome();
                              },
                              icon: Icon(Icons.camera_alt),
                              label: Text("Scan")),
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

class _RadioButtons extends HookViewModelWidget<ProductSearchHomeViewModel> {
  @override
  Widget buildViewModelWidget(BuildContext context, ProductSearchHomeViewModel model) {
    return Padding(
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
          Text(usedValue, style: TextStyle(color: Colors.white)),
          Radio(
            value: newValue,
            groupValue: model.condition.toString(),
            onChanged: (String newValue) {
              model.updateCondition(newValue);
            },
          ),
          Text(newValue, style: TextStyle(color: Colors.white))
        ],
      ),
    );
  }
}

class _CaptureButton extends HookViewModelWidget<ProductSearchHomeViewModel> {
  @override
  Widget buildViewModelWidget(BuildContext context, ProductSearchHomeViewModel viewModel) {
    // TODO: implement buildViewModelWidget
    throw UnimplementedError();
  }
}