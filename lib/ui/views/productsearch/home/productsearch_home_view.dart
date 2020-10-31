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
                      _selectionColumn(context, model),
                      _cameraButton(context, model)
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

Widget _selectionColumn(context, model) {
  return Container(
    alignment: Alignment.topCenter,
    child: Column(
      children: [
        SizedBox(height: 10.0),
        Text('Select Region: ',
            style: TextStyle(color: Colors.white, fontSize: 16.0)),
        _RegionSelection(),
        Text('Select Condition: ',
            style: TextStyle(color: Colors.white, fontSize: 16.0)),
        _RadioButtons()
      ],
    ),
  );
}

class _RegionSelection extends HookViewModelWidget<ProductSearchHomeViewModel> {
  @override
  Widget buildViewModelWidget(BuildContext context, ProductSearchHomeViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: DropdownButton<String>(
        value: viewModel.region,
        dropdownColor: standardPurple,
        icon: Icon(Icons.arrow_downward, color: standardPurple),
        iconSize: 18.0,
        elevation: 16,
        style: TextStyle(fontFamily: 'Oswald', color: Colors.white, fontSize: 16),
        underline: Container(
          height: 1,
          color: Colors.white,
        ),
        onChanged: (String newValue) {
          viewModel.updateRegion(newValue);
          debugPrint(viewModel.region);
        },
        items: regionList.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
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
            activeColor: standardPurple,
            value: usedValue,
            groupValue: model.condition.toString(),
            onChanged: (String newValue) {
              model.updateCondition(newValue);
            },
          ),
          Text(usedValue, style: TextStyle(color: Colors.white, fontSize: 18.0)),
          Radio(
            activeColor: standardPurple,
            value: newValue,
            groupValue: model.condition.toString(),
            onChanged: (String newValue) {
              model.updateCondition(newValue);
            },
          ),
          Text(newValue, style: TextStyle(color: Colors.white, fontSize: 18.0))
        ],
      ),
    );
  }
}

Widget _cameraButton(context, model) {
  return Padding(
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
        icon: Icon(Icons.camera_alt, color: Colors.white),
        label: Text("Scan", style: TextStyle(color: Colors.white)),
        color: standardGreen,
      ),
    ),
  );
}
