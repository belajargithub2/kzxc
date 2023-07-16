import 'package:wallpapers/app/modules/home/providers/related_provider.dart';
import 'package:wallpapers/app/modules/home/providers/wall_provider.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WallProvider>(
      () => WallProvider(),
    );
    Get.lazyPut<RelatedProvider>(
      () => RelatedProvider(),
    );
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
  }
}
