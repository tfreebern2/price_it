import 'package:auto_route/auto_route_annotations.dart';
import 'package:priceit/ui/views/home/selection_view.dart';
import 'package:priceit/ui/views/keywordsearch/active/keywordsearch_active_view.dart';
import 'package:priceit/ui/views/keywordsearch/completed/keywordsearch_completed_view.dart';
import 'package:priceit/ui/views/keywordsearch/home/keywordsearch_home_view.dart';
import 'package:priceit/ui/views/productsearch/home/productsearch_home_view.dart';

@MaterialAutoRouter()
class $Router {
  @initial
  SelectionView selectionView;
  KeywordSearchHomeView keywordSearchHomeView;
  KeywordSearchCompletedView keywordSearchCompletedView;
  KeywordSearchActiveView keywordSearchActiveView;
  ProductSearchHomeView productSearchHomeView;
}