import 'package:priceit/app/locator.dart';
import 'package:priceit/services/search_service.dart';
import 'package:stacked/stacked.dart';

class ProductSearchHomeViewModel extends ReactiveViewModel {
  final _searchService = locator<SearchService>();

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_searchService];
}