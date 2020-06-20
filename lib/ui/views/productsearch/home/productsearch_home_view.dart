import 'package:flutter/material.dart';
import 'package:priceit/ui/views/productsearch/home/productsearch_home_viewmodel.dart';
import 'package:priceit/ui/widgets/widgets.dart';
import 'package:stacked/stacked.dart';

class ProductSearchHomeView extends StatelessWidget {
  const ProductSearchHomeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProductSearchHomeViewModel>.nonReactive(
        builder: (context, model, child) => Scaffold(
          appBar: customAppbar(),
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Center(child: Text('Scan Product View', style: TextStyle(fontSize: 26.0),))
              ],
            ),
          ),
        ),
        viewModelBuilder: () => ProductSearchHomeViewModel());
  }
}
