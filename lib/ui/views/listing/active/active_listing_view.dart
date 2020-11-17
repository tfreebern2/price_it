import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:priceit/datamodels/item.dart';
import 'package:priceit/ui/views/listing/active/active_listing_viewmodel.dart';
import 'package:priceit/ui/widgets/widgets.dart';
import 'package:priceit/util/constants.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

class ActiveListingView extends StatelessWidget {
  const ActiveListingView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ActiveListingViewModel>.reactive(
        builder: (context, model, child) => Scaffold(
              appBar: _appBar(context, model),
              body: SafeArea(
                child: Center(
                  child: model.isBusy
                      ? CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(standardGreen))
                      : Column(
                          children: <Widget>[
                            SizedBox(
                              height: 30.0,
                            ),
                            _titleText(context),
                            _pricingText(context, model),
                            _SortSelection(),
                            _ItemListViewBuilder(),
                          ],
                        ),
                ),
              ),
            ),
        viewModelBuilder: () => ActiveListingViewModel());
  }
}

Widget _appBar(context, model) {
  return Platform.isIOS
      ? CupertinoNavigationBar(
          actionsForegroundColor: Colors.white,
          backgroundColor: standardGreen,
          middle: Text(
            'Price It!',
            style: TextStyle(
                fontFamily: 'Oswald',
                color: Colors.white,
                fontSize: 22.0,
                fontWeight: FontWeight.w600),
          ),
        )
      : AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: standardGreen,
          title: Text(
            'Price It!',
            style: TextStyle(
                fontFamily: 'Oswald',
                color: Colors.white,
                fontSize: 22.0,
                fontWeight: FontWeight.w600),
          ),
        );
}

Widget _titleText(context) {
  final deviceWidth = MediaQuery.of(context).size.width;
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Text(
      'Active Listings',
      style: TextStyle(
          fontSize: (deviceWidth < 380) ? 24.0 : 28.0,
          color: standardGreen,
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
                    color: Colors.black45,
                    fontSize: (deviceWidth < 380) ? 18.0 : 20.0,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                ' avg',
                style: TextStyle(
                    color: standardGreen,
                    fontSize: (deviceWidth < 380) ? 16.0 : 18.0,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        );
}

class _SortSelection extends HookViewModelWidget<ActiveListingViewModel> {
  @override
  Widget buildViewModelWidget(BuildContext context, ActiveListingViewModel viewModel) {
    return viewModel.hasError
        ? Container()
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Sort by:  ',
                    style: TextStyle(
                        fontFamily: 'Oswald',
                        color: Colors.black45,
                        fontSize: 16,
                        fontWeight: FontWeight.w600)),
                DropdownButton<String>(
                  value: viewModel.sortOrder,
                  icon: Icon(Icons.arrow_downward, color: Colors.black45),
                  iconSize: 18.0,
                  elevation: 16,
                  style: TextStyle(fontFamily: 'Oswald', color: standardGreen, fontSize: 16),
                  underline: Container(
                    height: 1,
                    color: Colors.black45,
                  ),
                  onChanged: (String newValue) {
                    viewModel.updateSortOrder(newValue);
                    debugPrint(viewModel.sortOrder);
                  },
                  items: sortList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                )
              ],
            ),
          );
  }
}

class _ItemListViewBuilder extends HookViewModelWidget<ActiveListingViewModel> {
  _ItemListViewBuilder({Key key}) : super(key: key, reactive: true);
  @override
  Widget buildViewModelWidget(BuildContext context, ActiveListingViewModel viewModel) {
    return viewModel.hasError
        ? Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text('Nothing to see here...', style: TextStyle(fontSize: 26.0)),
          )
        : Expanded(
            child: ListView.builder(
                itemCount: viewModel.data.activeListing.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  if (viewModel.sortOrder == bestMatchSelection) {
                    List<Item> bestMatchList = viewModel.data.activeListing;
                    bestMatchList.sort((a, b) => b.title.compareTo(a.title));
                    viewModel.searchService.setBestMatchList(bestMatchList);
                    Item item = viewModel.searchService.bestMatchList[index];
                    return cardItem(context, viewModel, item);
                  } else if (viewModel.sortOrder == highestPrice) {
                    List<Item> highPriceList = viewModel.data.activeListing;
                    highPriceList.sort((a, b) => b.currentPrice.compareTo(a.currentPrice));
                    viewModel.searchService.setHighPriceList(highPriceList);
                    Item item = viewModel.searchService.highPriceList[index];
                    return cardItem(context, viewModel, item);
                  } else {
                    List<Item> lowPriceList = viewModel.data.activeListing;
                    lowPriceList.sort((a, b) => a.currentPrice.compareTo(b.currentPrice));
                    viewModel.searchService.setLowPriceList(lowPriceList);
                    Item item = viewModel.searchService.lowPriceList[index];
                    return cardItem(context, viewModel, item);
                  }
                }),
          );
  }
}

Widget cardItem(BuildContext context, ActiveListingViewModel viewModel, Item item) {
  return Padding(
    padding: const EdgeInsets.all(2.0),
    child: Card(
      elevation: 6.00,
      shadowColor: Colors.black,
      child: ListTile(
        contentPadding: EdgeInsets.all(12.0),
        leading: item.galleryUrl.isNotEmpty
            ? Image.network(item.galleryUrl)
            : Text('Image Not' + '\n' + 'Available', textAlign: TextAlign.center),
        title: Text(item.title, style: TextStyle(color: standardGreen)),
        trailing: Text(
          item.currencySymbol + " " + item.currentPriceString,
          style: TextStyle(color: Colors.black45, fontWeight: FontWeight.bold),
        ),
        onTap: () => item.viewItemUrl.isNotEmpty
            ? viewModel.launchUrl(item.viewItemUrl)
            : showNoLaunchUrl(context, viewModel),
      ),
    ),
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
