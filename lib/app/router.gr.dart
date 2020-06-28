// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/auto_route.dart';
import 'package:priceit/ui/views/home/selection_view.dart';
import 'package:priceit/ui/views/keywordsearch/home/keywordsearch_home_view.dart';
import 'package:priceit/ui/views/keywordsearch/completed/keywordsearch_completed_view.dart';
import 'package:priceit/ui/views/keywordsearch/active/keywordsearch_active_view.dart';
import 'package:priceit/ui/views/productsearch/home/productsearch_home_view.dart';
import 'package:priceit/ui/views/productsearch/photodetail/productsearch_photodetail_view.dart';

abstract class Routes {
  static const selectionView = '/';
  static const keywordSearchHomeView = '/keyword-search-home-view';
  static const keywordSearchCompletedView = '/keyword-search-completed-view';
  static const keywordSearchActiveView = '/keyword-search-active-view';
  static const productSearchHomeView = '/product-search-home-view';
  static const productSearchPhotoDetailView =
      '/product-search-photo-detail-view';
  static const all = {
    selectionView,
    keywordSearchHomeView,
    keywordSearchCompletedView,
    keywordSearchActiveView,
    productSearchHomeView,
    productSearchPhotoDetailView,
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
      case Routes.keywordSearchHomeView:
        if (hasInvalidArgs<KeywordSearchHomeViewArguments>(args)) {
          return misTypedArgsRoute<KeywordSearchHomeViewArguments>(args);
        }
        final typedArgs = args as KeywordSearchHomeViewArguments ??
            KeywordSearchHomeViewArguments();
        return MaterialPageRoute<dynamic>(
          builder: (context) => KeywordSearchHomeView(key: typedArgs.key),
          settings: settings,
        );
      case Routes.keywordSearchCompletedView:
        if (hasInvalidArgs<KeywordSearchCompletedViewArguments>(args)) {
          return misTypedArgsRoute<KeywordSearchCompletedViewArguments>(args);
        }
        final typedArgs = args as KeywordSearchCompletedViewArguments ??
            KeywordSearchCompletedViewArguments();
        return MaterialPageRoute<dynamic>(
          builder: (context) => KeywordSearchCompletedView(key: typedArgs.key),
          settings: settings,
        );
      case Routes.keywordSearchActiveView:
        if (hasInvalidArgs<KeywordSearchActiveViewArguments>(args)) {
          return misTypedArgsRoute<KeywordSearchActiveViewArguments>(args);
        }
        final typedArgs = args as KeywordSearchActiveViewArguments ??
            KeywordSearchActiveViewArguments();
        return MaterialPageRoute<dynamic>(
          builder: (context) => KeywordSearchActiveView(key: typedArgs.key),
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

//KeywordSearchHomeView arguments holder class
class KeywordSearchHomeViewArguments {
  final Key key;
  KeywordSearchHomeViewArguments({this.key});
}

//KeywordSearchCompletedView arguments holder class
class KeywordSearchCompletedViewArguments {
  final Key key;
  KeywordSearchCompletedViewArguments({this.key});
}

//KeywordSearchActiveView arguments holder class
class KeywordSearchActiveViewArguments {
  final Key key;
  KeywordSearchActiveViewArguments({this.key});
}

//ProductSearchHomeView arguments holder class
class ProductSearchHomeViewArguments {
  final Key key;
  ProductSearchHomeViewArguments({this.key});
}
