import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:priceit/ui/views/productsearch/home/productsearch_home_viewmodel.dart';
import 'package:priceit/ui/widgets/widgets.dart';
import 'package:stacked/stacked.dart';

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
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: RaisedButton.icon(onPressed: () {
                      model.data.takePicture().then((path) => {
                        if (path != null) {
                          model.navigateToHome()
                        }
                      });
                    },
                        icon: Icon(Icons.camera_alt), label: Text("Scan")),
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
