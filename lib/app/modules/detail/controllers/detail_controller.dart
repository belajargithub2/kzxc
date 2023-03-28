import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:wallpapers/app/modules/home/controllers/home_controller.dart';
import 'package:wallpapers/app/utils/toast.dart';
import 'package:get/get.dart';
import 'package:wallpaper_manager_flutter/wallpaper_manager_flutter.dart';

class DetailController extends GetxController {
  final imageUrl = "".obs;
  final isLoading = false.obs;
  final homeC = Get.find<HomeController>();

  @override
  void onInit() {
    super.onInit();
    imageUrl("${Get.arguments}");
  }

  void showDialog() {
    Get.bottomSheet(
      Container(
        height: 280,
        width: double.infinity,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          color: Colors.white,
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            btnSetWallpaper(
              "Set as Homescreen",
              WallpaperManagerFlutter.HOME_SCREEN,
            ),
            btnSetWallpaper(
              "Set as Lockscreen",
              WallpaperManagerFlutter.LOCK_SCREEN,
            ),
            btnSetWallpaper(
              "Set as Bothscreen",
              WallpaperManagerFlutter.BOTH_SCREENS,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size.fromWidth(Get.width / 1.1),
                padding: const EdgeInsets.all(15),
                backgroundColor: Colors.grey[400],
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () => Get.back(),
              child: const Text(
                "Cancel",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget btnSetWallpaper(String title, int position) {
    return TextButton(
      style: ElevatedButton.styleFrom(
        fixedSize: Size.fromWidth(Get.width / 1.1),
        padding: const EdgeInsets.all(15),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w300,
          color: Colors.black,
        ),
      ),
      onPressed: () {
        Get.back();
        isLoading(true);
        setWallpaper(position);
      },
    );
  }

  Future<void> setWallpaper(location) async {
    homeC.showInterstitial();
    var file = await DefaultCacheManager().getSingleFile(imageUrl.value);
    try {
      await WallpaperManagerFlutter().setwallpaperfromFile(file, location);
      successToast("Success set wallpaper");
    } catch (e) {
      alertToast("Failed set wallpaper : $e}");
    }
    isLoading(false);
  }
}
