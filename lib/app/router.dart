import 'package:auto_route/auto_route_annotations.dart';
import 'package:priceit/ui/views/home/home_view.dart';

@MaterialAutoRouter()
class $Router {
  @initial
  HomeView homeViewRoute;
}