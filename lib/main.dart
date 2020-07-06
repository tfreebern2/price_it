import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:priceit/ui/views/home/selection_view.dart';
import 'package:stacked_services/stacked_services.dart';

import 'app/locator.dart';
import 'app/router.gr.dart';

void main() async {
  await DotEnv().load('.env');
  setupLocator();
  // TODO: Resolve orientation in camera preview
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Price It',
      theme: ThemeData(
        fontFamily: 'Oswald',
        primarySwatch: Colors.lightGreen,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SelectionView(),
      onGenerateRoute: Router().onGenerateRoute,
      navigatorKey: locator<NavigationService>().navigatorKey,
    );
  }
}