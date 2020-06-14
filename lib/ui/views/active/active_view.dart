import 'package:flutter/material.dart';
import 'package:priceit/datamodels/item.dart';
import 'package:priceit/ui/views/active/active_viewmodel.dart';
import 'package:stacked/stacked.dart';

class ActiveView extends StatelessWidget {
  const ActiveView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ActiveViewModel>.nonReactive(
        builder: (context, model, child) => Scaffold(
              body: SafeArea(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 80.0,
                        child: Center(child: Text('Ad Space')),
                      ),
                      _buttonBar(model, context),
                      _titleText(context),
                      _pricingText(model, context),
                      _itemListViewBuilder(model),
                    ],
                  ),
                ),
              ),
            ),
        viewModelBuilder: () => ActiveViewModel());
  }
}

Widget _buttonBar(model, context) {
  return ButtonBar(
    mainAxisSize: MainAxisSize.max,
    alignment: MainAxisAlignment.center,
    buttonTextTheme: ButtonTextTheme.accent,
    children: <Widget>[
      MaterialButton(
        child: Text(
          'Search',
          style: TextStyle(color: Colors.white),
        ),
        color: Theme.of(context).buttonColor,
        onPressed: () => model.navigateToHome(),
        highlightElevation: 2,
        height: 40,
        minWidth: 150,
        shape: StadiumBorder(),
      ),
      MaterialButton(
        child: Text('Completed Listings', style: TextStyle(color: Colors.white)),
        color: Theme.of(context).accentColor,
        onPressed: () => model.navigateToComplete(),
        highlightElevation: 2,
        height: 40,
        minWidth: 150,
        shape: UnderlineInputBorder(),
      ),
    ],
  );
}

Widget _titleText(context) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Text(
      'Active Listings',
      style: TextStyle(fontSize: 24.0, color: Theme.of(context).accentColor),
    ),
  );
}

Widget _pricingText(model, context) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          '\$ ' + model.searchService.activeListingAveragePrice.toStringAsFixed(2),
          style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        Text(
          ' avg',
          style: TextStyle(color: Theme.of(context).accentColor, fontSize: 18.0),
        )
      ],
    ),
  );
}

Widget _itemListViewBuilder(model) {
  return Expanded(
    child: ListView.builder(
        itemCount: model.searchService.activeListing.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          Item item = model.searchService.activeListing[index];
          return Padding(
            padding: const EdgeInsets.all(2.0),
            child: Card(
              elevation: 6.00,
              shadowColor: Theme.of(context).accentColor,
              child: ListTile(
                contentPadding: EdgeInsets.all(12.0),
                leading: Image.network(item.galleryUrl),
                title: Text(item.title),
                trailing: Text(
                  item.currentPrice,
                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                ),
                onTap: () => model.launchUrl(item.viewItemUrl),
              ),
            ),
          );
        }),
  );
}
