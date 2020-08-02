import 'package:flutter/material.dart';

Widget customAppbar() {
  return AppBar(
    automaticallyImplyLeading: false,
    title: Text(
      'PriceIt',
      style: TextStyle(fontFamily: 'Oswald', color: Colors.black, fontSize: 22.0, fontWeight: FontWeight.bold),
    ),
  );
}

Widget listingSearchButton(context, model) {
  return MaterialButton(
    child: Text(
      'Search',
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
    ),
    color: Theme.of(context).accentColor,
    onPressed: () => model.navigateToSelectionView(),
    highlightElevation: 2,
    height: 40,
    minWidth: 150,
    shape: StadiumBorder(),
  );
}

Widget searchByKeywordButton(context, model) {
  return MaterialButton(
    child: Text(
      'Search By Keyword',
      style: TextStyle(color: Colors.black, fontSize: 22.0, fontWeight: FontWeight.w600),
    ),
    color: Theme.of(context).accentColor,
    onPressed: () => model.navigateToKeyword(),
    highlightElevation: 2,
    height: 100,
    minWidth: 250,
    shape: OutlineInputBorder(),
  );
}

Widget searchByProductButton(context, model) {
  return MaterialButton(
    child: Text(
      'Scan Product',
      style: TextStyle(color: Colors.black, fontSize: 22.0, fontWeight: FontWeight.w600),
    ),
    color: Theme.of(context).accentColor,
    onPressed: () => model.navigateToProduct(),
    highlightElevation: 2,
    height: 100,
    minWidth: 250,
    shape: OutlineInputBorder(),
  );
}