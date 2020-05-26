import 'package:auto_route/auto_route_annotations.dart';
import 'package:injectable/injectable.dart';
import 'package:observable_ish/observable_ish.dart';
import 'package:stacked/stacked.dart';

@lazySingleton
class SelectorService with ReactiveServiceMixin {
  RxValue<String> _value = RxValue<String>(initial: 'Used');
  String get value => _value.value;

  SelectorService() {
    listenToReactiveValues([_value]);
  }
}