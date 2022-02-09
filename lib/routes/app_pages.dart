import 'package:get/get.dart';
import '../core.dart';

part 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => HomeView(),
      // binding: HomeBinding(),
    ),
  ];
}
