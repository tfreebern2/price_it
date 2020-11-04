import 'package:flutter/material.dart';
import 'package:priceit/util/constants.dart';

Widget customAppbar() {
  return AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: standardGreen,
    title: Text(
      'Price It!',
      style: TextStyle(fontFamily: 'Oswald', color: Colors.white, fontSize: 22.0, fontWeight: FontWeight.w600),
    ),
  );
}

Widget listingSearchButton(context, model) {
  final deviceWidth = MediaQuery.of(context).size.width;
  return MaterialButton(
    child: Text(
      'Search',
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
    ),
    color: standardGreen,
    onPressed: () => model.navigateToSelectionView(),
    highlightElevation: 2,
    height: 40,
    minWidth: (deviceWidth < 360) ? 140 : 150,
    shape: StadiumBorder(),
  );
}

Widget searchByKeywordButton(context, model) {
  return MaterialButton(
    child: Text(
      'Search By Keyword',
      style: TextStyle(fontFamily: 'Oswald', color: Colors.white, fontSize: 22.0, fontWeight: FontWeight.w600),
    ),
    color: standardPurple,
    onPressed: () => model.navigateToKeyword(),
    highlightElevation: 2,
    height: 100,
    minWidth: 250,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
    ),
  );
}

Widget searchByProductButton(context, model) {
  return MaterialButton(
    child: Text(
      'Scan Product',
      style: TextStyle(color: Colors.white, fontSize: 22.0, fontWeight: FontWeight.w600),
    ),
    color: standardPurple,
    onPressed: () => model.navigateToProduct(),
    highlightElevation: 2,
    height: 100,
    minWidth: 250,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
    ),
  );
}