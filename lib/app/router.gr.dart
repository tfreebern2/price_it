// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/auto_route.dart';
import 'package:priceit/ui/views/home/selection_view.dart';
import 'package:priceit/ui/views/keywordsearch/home/keywordsearch_view.dart';
import 'package:priceit/ui/views/productsearch/home/productsearch_home_view.dart';
import 'package:priceit/ui/views/productsearch/photodetail/productsearch_photodetail_view.dart';
import 'package:priceit/ui/views/listing/completed/completed_listing_view.dart';
import 'package:priceit/ui/views/listing/active/active_listing_view.dart';

abstract class Routes {
  static const selectionView = '/';
  static const keywordSearchView = '/keyword-search-view';
  static const productSearchHomeView = '/product-search-home-view';
  static const productSearchPhotoDetailView =
      '/product-search-photo-detail-view';
  static const completedListingView = '/completed-listing-view';
  static const activeListingView = '/active-listing-view';
  static const all = {
    selectionView,
    keywordSearchView,
    productSearchHomeView,
    productSearchPhotoDetailView,
    completedListingView,
    activeListingView,
  };
}

class Router extends RouterBase {
  @override
  Set<String> get allRoutes => Routes.all;

  @Deprecated('call ExtendedNavigator.ofRouter<Router>() directly')
  static ExtendedNavigatorState get navigator =>
      ExtendedNavigator.ofRouter<Router>();

  @override
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Routes.selectionView:
        if (hasInvalidArgs<SelectionViewArguments>(args)) {
          return misTypedArgsRoute<SelectionViewArguments>(args);
        }
        final typedArgs =
            args as SelectionViewArguments ?? SelectionViewArguments();
        return MaterialPageRoute<dynamic>(
          builder: (context) => SelectionView(key: typedArgs.key),
          settings: settings,
        );
      case Routes.keywordSearchView:
        if (hasInvalidArgs<KeywordSearchViewArguments>(args)) {
          return misTypedArgsRoute<KeywordSearchViewArguments>(args);
        }
        final typedArgs =
            args as KeywordSearchViewArguments ?? KeywordSearchViewArguments();
        return MaterialPageRoute<dynamic>(
          builder: (context) => KeywordSearchView(key: typedArgs.key),
          settings: settings,
        );
      case Routes.productSearchHomeView:
        if (hasInvalidArgs<ProductSearchHomeViewArguments>(args)) {
          return misTypedArgsRoute<ProductSearchHomeViewArguments>(args);
        }
        final typedArgs = args as ProductSearchHomeViewArguments ??
            ProductSearchHomeViewArguments();
        return MaterialPageRoute<dynamic>(
          builder: (context) => ProductSearchHomeView(key: typedArgs.key),
          settings: settings,
        );
      case Routes.productSearchPhotoDetailView:
        return MaterialPageRoute<dynamic>(
          builder: (context) => ProductSearchPhotoDetailView(),
          settings: settings,
        );
      case Routes.completedListingView:
        if (hasInvalidArgs<CompletedListingViewArguments>(args)) {
          return misTypedArgsRoute<CompletedListingViewArguments>(args);
        }
        final typedArgs = args as CompletedListingViewArguments ??
            CompletedListingViewArguments();
        return MaterialPageRoute<dynamic>(
          builder: (context) => CompletedListingView(key: typedArgs.key),
          settings: settings,
        );
      case Routes.activeListingView:
        if (hasInvalidArgs<ActiveListingViewArguments>(args)) {
          return misTypedArgsRoute<ActiveListingViewArguments>(args);
        }
        final typedArgs =
            args as ActiveListingViewArguments ?? ActiveListingViewArguments();
        return MaterialPageRoute<dynamic>(
          builder: (context) => ActiveListingView(key: typedArgs.key),
          settings: settings,
        );
      default:
        return unknownRoutePage(settings.name);
    }
  }
}

// *************************************************************************
// Arguments holder classes
// **************************************************************************

//SelectionView arguments holder class
class SelectionViewArguments {
  final Key key;
  SelectionViewArguments({this.key});
}

//KeywordSearchView arguments holder class
class KeywordSearchViewArguments {
  final Key key;
  KeywordSearchViewArguments({this.key});
}

//ProductSearchHomeView arguments holder class
class ProductSearchHomeViewArguments {
  final Key key;
  ProductSearchHomeViewArguments({this.key});
}

//CompletedListingView arguments holder class
class CompletedListingViewArguments {
  final Key key;
  CompletedListingViewArguments({this.key});
}

//ActiveListingView arguments holder class
class ActiveListingViewArguments {
  final Key key;
  ActiveListingViewArguments({this.key});
}
