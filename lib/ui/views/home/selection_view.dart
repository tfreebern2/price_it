import 'package:flutter/material.dart';
import 'package:priceit/ui/views/home/selection_viewmodel.dart';
import 'package:priceit/ui/widgets/widgets.dart';
import 'package:stacked/stacked.dart';

class SelectionView extends StatelessWidget {
  const SelectionView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SelectionViewModel>.nonReactive(
        builder: (context, model, child) => Scaffold(
              appBar: customAppbar(),
              body: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 180.0,
                      child: Center(child: Text('Ad Space')),
                    ),
                    searchByKeywordButton(context, model),
                    SizedBox(
                      height: 100.0,
                    ),
                    searchByProductButton(context, model),
                  ],
                ),
              ),
            ),
        viewModelBuilder: () => SelectionViewModel());
  }
}
