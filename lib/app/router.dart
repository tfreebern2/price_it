import 'package:auto_route/auto_route_annotations.dart';
import 'package:resalechecker/ui/views/home/home_view.dart';

@MaterialAutoRouter()
class $Router {
  @initial
  HomeView homeViewRoute;
}