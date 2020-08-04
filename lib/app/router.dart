import 'package:auto_route/auto_route_annotations.dart';
import 'package:priceit/ui/views/home/selection_view.dart';
import 'package:priceit/ui/views/listing/active/active_listing_view.dart';
import 'package:priceit/ui/views/listing/completed/completed_listing_view.dart';
import 'package:priceit/ui/views/keywordsearch/home/keywordsearch_view.dart';
import 'package:priceit/ui/views/productsearch/home/productsearch_home_view.dart';
import 'package:priceit/ui/views/productsearch/photodetail/productsearch_photodetail_view.dart';

@MaterialAutoRouter()
class $Router {
  @initial
  SelectionView selectionView;
  KeywordSearchView keywordSearchView;
  ProductSearchHomeView productSearchHomeView;
  ProductSearchPhotoDetailView productSearchPhotoDetailView;
  CompletedListingView completedListingView;
  ActiveListingView activeListingView;
}