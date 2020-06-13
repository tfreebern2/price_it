// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/auto_route.dart';
import 'package:priceit/ui/views/home/home_view.dart';
import 'package:priceit/ui/views/completed/completed_view.dart';
import 'package:priceit/ui/views/active/active_view.dart';

abstract class Routes {
  static const homeViewRoute = '/';
  static const completedView = '/completed-view';
  static const activeView = '/active-view';
  static const all = {
    homeViewRoute,
    completedView,
    activeView,
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
      case Routes.homeViewRoute:
        if (hasInvalidArgs<HomeViewArguments>(args)) {
          return misTypedArgsRoute<HomeViewArguments>(args);
        }
        final typedArgs = args as HomeViewArguments ?? HomeViewArguments();
        return MaterialPageRoute<dynamic>(
          builder: (context) => HomeView(key: typedArgs.key),
          settings: settings,
        );
      case Routes.completedView:
        if (hasInvalidArgs<CompletedViewArguments>(args)) {
          return misTypedArgsRoute<CompletedViewArguments>(args);
        }
        final typedArgs =
            args as CompletedViewArguments ?? CompletedViewArguments();
        return MaterialPageRoute<dynamic>(
          builder: (context) => CompletedView(key: typedArgs.key),
          settings: settings,
        );
      case Routes.activeView:
        if (hasInvalidArgs<ActiveViewArguments>(args)) {
          return misTypedArgsRoute<ActiveViewArguments>(args);
        }
        final typedArgs = args as ActiveViewArguments ?? ActiveViewArguments();
        return MaterialPageRoute<dynamic>(
          builder: (context) => ActiveView(key: typedArgs.key),
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

//HomeView arguments holder class
class HomeViewArguments {
  final Key key;
  HomeViewArguments({this.key});
}

//CompletedView arguments holder class
class CompletedViewArguments {
  final Key key;
  CompletedViewArguments({this.key});
}

//ActiveView arguments holder class
class ActiveViewArguments {
  final Key key;
  ActiveViewArguments({this.key});
}
