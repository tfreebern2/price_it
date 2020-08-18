import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:priceit/datamodels/item.dart';
import 'package:priceit/ui/views/listing/completed/completed_listing_viewmodel.dart';
import 'package:priceit/ui/widgets/widgets.dart';
import 'package:stacked/stacked.dart';

class CompletedListingView extends StatelessWidget {
  const CompletedListingView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CompletedListingViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        appBar: customAppbar(),
        // TODO: Revisit this WillPopScope
        body: WillPopScope(
          onWillPop: () => onBack(model),
          child: SafeArea(
            child: Center(
              child: model.isBusy
                  ? CircularProgressIndicator()
                  : Column(
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
      ),
      viewModelBuilder: () => CompletedListingViewModel(),
    );
  }
}

Future<bool> onBack(model) async {
  model.searchService.resetSearchResultState();
  return true;
}

Widget _buttonBar(context, model) {
  return ButtonBar(
    mainAxisSize: MainAxisSize.max,
    alignment: MainAxisAlignment.center,
    buttonTextTheme: ButtonTextTheme.accent,
    children: <Widget>[
      MaterialButton(
        child: Text(
          'Completed Listings',
          style: TextStyle(color: Colors.white),
        ),
        color: Theme.of(context).buttonColor,
        onPressed: () => null,
        highlightElevation: 2,
        height: 40,
        minWidth: 150,
        shape: UnderlineInputBorder(),
      ),
      MaterialButton(
        child: Text(
          'Active Listings',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        color: Theme.of(context).accentColor,
        onPressed: () => model.navigateToActiveListingView(),
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
      'Completed Listings',
      style: TextStyle(
          fontSize: 24.0, color: Theme.of(context).accentColor, fontWeight: FontWeight.w600),
    ),
  );
}

Widget _pricingText(context, model) {
  return model.hasError
      ? Container()
      : Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                '\$ ' + model.data.completedListingAveragePrice.toStringAsFixed(2),
                style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              Text(
                ' avg (sold only) ',
                style: TextStyle(color: Theme.of(context).accentColor, fontSize: 18.0),
              ),
              Text(
                model.data.completedListingPercentageSold.toStringAsFixed(2),
                style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              Text(' % sold',
                  style: TextStyle(color: Theme.of(context).accentColor, fontSize: 18.0)),
            ],
          ),
        );
}

Widget _itemListViewBuilder(context, model) {
  return model.hasError
      ? Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text('Nothing to see here...', style: TextStyle(fontSize: 22.0)),
        )
      : Expanded(
          child: ListView.builder(
              itemCount: model.data.completedListing.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                Item item = model.data.completedListing[index];
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
                        style: TextStyle(color: Colors.lightGreen, fontWeight: FontWeight.bold),
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
            title: Text('Something went wrong!'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [Text('Can not access this auction.')],
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
            title: Text('Something went wrong!'),
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
