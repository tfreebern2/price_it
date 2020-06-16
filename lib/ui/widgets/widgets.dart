import 'package:flutter/material.dart';

Widget customAppbar() {
  return AppBar(
    automaticallyImplyLeading: false,
    title: Text('PriceIt', style: TextStyle(fontFamily: 'Oswald', fontSize: 22.0, fontWeight: FontWeight.bold),),
  );
}

Widget listingSearchButton(context, model) {
  return MaterialButton(
    child: Text(
      'Search',
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
    ),
    color: Theme.of(context).accentColor,
    onPressed: () => model.navigateToHome(),
    highlightElevation: 2,
    height: 40,
    minWidth: 150,
    shape: StadiumBorder(),
  );
}