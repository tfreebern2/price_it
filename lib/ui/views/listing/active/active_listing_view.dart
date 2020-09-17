import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:priceit/datamodels/item.dart';
import 'package:priceit/ui/views/listing/active/active_listing_viewmodel.dart';
import 'package:priceit/ui/widgets/widgets.dart';
import 'package:stacked/stacked.dart';

class ActiveListingView extends StatelessWidget {
  const ActiveListingView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ActiveListingViewModel>.nonReactive(
        builder: (context, model, child) => Scaffold(
              appBar: customAppbar(),
              body: SafeArea(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 20.0,
                      ),
                      listingSearchButton(context, model),
                      _buttonBar(context, model),
                      _titleText(context),
                      _pricingText(context, model),
                      _itemListViewBuilder(context, model),
                    ],
                  ),
                ),
              ),
            ),
        viewModelBuilder: () => ActiveListingViewModel());
  }
}

Widget _buttonBar(context, model) {
  final deviceWidth = MediaQuery.of(context).size.width;
  return ButtonBar(
    mainAxisSize: MainAxisSize.max,
    alignment: MainAxisAlignment.center,
    buttonTextTheme: ButtonTextTheme.accent,
    children: <Widget>[
      MaterialButton(
        child: Text('Completed Listings',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        color: Theme.of(context).accentColor,
        onPressed: () => model.navigateToCompletedListingView(),
        highlightElevation: 2,
        height: 40,
        minWidth: (deviceWidth < 360) ? 140 : 150,
        shape: UnderlineInputBorder(),
      ),
      MaterialButton(
        child: Text('Active Listings', style: TextStyle(color: Colors.white)),
        color: Theme.of(context).buttonColor,
        onPressed: () => null,
        highlightElevation: 2,
        height: 40,
        minWidth: (deviceWidth < 360) ? 140 : 150,
        shape: UnderlineInputBorder(),
      ),
    ],
  );
}

Widget _titleText(context) {
  final deviceWidth = MediaQuery.of(context).size.width;
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Text(
      'Active Listings',
      style: TextStyle(
          fontSize: (deviceWidth < 360) ? 22.0 : 24.0,
          color: Theme.of(context).accentColor,
          fontWeight: FontWeight.w600),
    ),
  );
}

Widget _pricingText(context, model) {
  final deviceWidth = MediaQuery.of(context).size.width;
  return model.searchService.apiError
      ? Container()
      : Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                '\$ ' + model.searchService.activeListingAveragePrice.toStringAsFixed(2),
                style: TextStyle(
                    color: Colors.black,
                    fontSize: (deviceWidth < 360) ? 18.0 : 20.0,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                ' avg',
                style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontSize: (deviceWidth < 360) ? 16.0 : 18.0),
              )
            ],
          ),
        );
}

Widget _itemListViewBuilder(context, model) {
  return model.searchService.apiError
      ? Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text('Nothing to see here...', style: TextStyle(fontSize: 22.0)),
        )
      : Expanded(
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
                      leading: item.galleryUrl.isNotEmpty
                          ? Image.network(item.galleryUrl)
                          : Text('Image Not' + '\n' + 'Available'),
                      title: Text(item.title),
                      trailing: Text(
                        item.currentPrice,
                        style: TextStyle(
                            color: Theme.of(context).accentColor, fontWeight: FontWeight.bold),
                      ),
                      onTap: () => item.viewItemUrl.isNotEmpty
                          ? model.launchUrl(item.viewItemUrl)
                          : showNoLaunchUrl(context, model),
                    ),
                  ),
                );
              }),
        );
}

Future<void> showNoLaunchUrl(context, model) async {
  return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        if (Platform.isAndroid) {
          return AlertDialog(
            title: Text('Can not access auction'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [Text('There is no access')],
              ),
            ),
            actions: [
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  model.navigationService.popRepeated(0);
                },
              )
            ],
          );
        } else {
          return CupertinoAlertDialog(
            title: Text('Can not access auction'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [Text('Can not access this auction.')],
              ),
            ),
            actions: [
              CupertinoDialogAction(
                child: Text('Ok'),
                onPressed: () {
                  model.navigationService.popRepeated(0);
                },
              )
            ],
          );
        }
      });
}
