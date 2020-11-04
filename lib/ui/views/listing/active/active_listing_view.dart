import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:priceit/datamodels/item.dart';
import 'package:priceit/ui/views/listing/active/active_listing_viewmodel.dart';
import 'package:priceit/ui/widgets/widgets.dart';
import 'package:priceit/util/constants.dart';
import 'package:stacked/stacked.dart';

class ActiveListingView extends StatelessWidget {
  const ActiveListingView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ActiveListingViewModel>.reactive(
        builder: (context, model, child) => Scaffold(
              appBar: customAppbar(),
              body: SafeArea(
                child: Center(
                  child: model.isBusy
                      ? CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(standardPurple))
                      : Column(
                          children: <Widget>[
                            SizedBox(
                              height: 30.0,
                            ),
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

Widget _titleText(context) {
  final deviceWidth = MediaQuery.of(context).size.width;
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Text(
      'Active Listings',
      style: TextStyle(
          fontSize: (deviceWidth < 360) ? 22.0 : 28.0,
          color: Color.fromRGBO(141, 108, 159, 1),
          fontWeight: FontWeight.w600),
    ),
  );
}

Widget _pricingText(context, model) {
  final deviceWidth = MediaQuery.of(context).size.width;
  return model.hasError
      ? Container(height: 100)
      : Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                model.data.currencySymbol +
                    " " +
                    model.data.activeListingAveragePrice.toStringAsFixed(2),
                style: TextStyle(
                    color: standardGreen,
                    fontSize: (deviceWidth < 360) ? 18.0 : 20.0,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                ' avg',
                style: TextStyle(
                    color: Color.fromRGBO(141, 108, 159, 1),
                    fontSize: (deviceWidth < 360) ? 16.0 : 18.0,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        );
}

Widget _itemListViewBuilder(context, model) {
  return model.hasError
      ? Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text('Nothing to see here...', style: TextStyle(fontSize: 26.0)),
        )
      : Expanded(
          child: ListView.builder(
              itemCount: model.data.activeListing.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                Item item = model.data.activeListing[index];
                return Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Card(
                    elevation: 6.00,
                    shadowColor: standardPurple,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(12.0),
                      leading: item.galleryUrl.isNotEmpty
                          ? Image.network(item.galleryUrl)
                          : Text('Image Not' + '\n' + 'Available'),
                      title: Text(item.title, style: TextStyle(color: standardPurple)),
                      trailing: Text(
                        item.currencySymbol + " " + item.currentPrice,
                        style: TextStyle(color: standardGreen, fontWeight: FontWeight.bold),
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
