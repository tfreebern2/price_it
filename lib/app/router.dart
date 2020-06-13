import 'package:auto_route/auto_route_annotations.dart';
import 'package:priceit/ui/views/active/active_view.dart';
import 'package:priceit/ui/views/completed/completed_view.dart';
import 'package:priceit/ui/views/home/home_view.dart';

@MaterialAutoRouter()
class $Router {
  @initial
  HomeView homeViewRoute;
  CompletedView completedView;
  ActiveView activeView;
}