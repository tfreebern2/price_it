import 'package:flutter/material.dart';
import 'package:priceit/datamodels/item.dart';
import 'package:priceit/ui/views/completed/completed_viewmodel.dart';
import 'package:stacked/stacked.dart';

class CompletedView extends StatelessWidget {
  const CompletedView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CompletedViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          leading: Container(),
          title: Text("PriceIt"),
        ),
        body: SafeArea(
          child: Center(
            child: model.isBusy
                ? CircularProgressIndicator()
                : Column(
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
      viewModelBuilder: () => CompletedViewModel(),
    );
  }
}

Widget _errorContainer() {
  return Container(
      color: Colors.red,
      alignment: Alignment.center,
      child: Text('An error has occurred', style: TextStyle(color: Colors.white)));
}

Widget _titleText(context) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Text(
      'Completed Sales',
      style: TextStyle(fontSize: 24.0, color: Theme.of(context).accentColor),
    ),
  );
}

Widget _pricingText(model, context) {
  if (model.data != null) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            '\$ ' + model.completedListingAveragePrice.toStringAsFixed(2),
            style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          Text(
            ' avg (sold only) ',
            style: TextStyle(color: Theme
                .of(context)
                .accentColor, fontSize: 18.0),
          ),
          Text(
            model.completedListingPercentageSold.toStringAsFixed(2),
            style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          Text(' % sold', style: TextStyle(color: Theme
              .of(context)
              .accentColor, fontSize: 18.0)),
        ],
      ),
    );
  } else {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            '\$ ' + model.searchService.completedListingAveragePrice.toStringAsFixed(2),
            style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          Text(
            ' avg (sold only) ',
            style: TextStyle(color: Theme
                .of(context)
                .accentColor, fontSize: 18.0),
          ),
          Text(
            model.searchService.completedListingPercentageSold.toStringAsFixed(2),
            style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          Text(' % sold', style: TextStyle(color: Theme
              .of(context)
              .accentColor, fontSize: 18.0)),
        ],
      ),
    );
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
          color: Theme.of(context).accentColor,
          onPressed: () => model.navigateToHome()),
      MaterialButton(
          child: Text(
            'Current Listing',
            style: TextStyle(color: Colors.white),
          ),
          color: Theme.of(context).accentColor,
          onPressed: () => model.navigateToActive()),
    ],
  );
}

Widget _itemListViewBuilder(model) {
  if (model.data != null) {
    return Expanded(
      child: ListView.builder(
          itemCount: model.data.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            Item item = model.data[index];
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
  } else {
    return Expanded(
      child: ListView.builder(
          itemCount: model.searchService.completedListing.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            Item item = model.searchService.completedListing[index];
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
}
