import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core.dart';

void main() async {
  /// Make sure you add this line here, so the plugin can access the native side
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Car Rental',
      initialRoute: Routes.HOME,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.cupertino,
      opaqueRoute: Get.isOpaqueRouteDefault,
      popGesture: Get.isPopGestureEnable,
      transitionDuration: Duration(milliseconds: 230),
    );
  }
}
