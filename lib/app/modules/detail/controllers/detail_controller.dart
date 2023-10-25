import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wallpapers/app/modules/home/controllers/home_controller.dart';
import 'package:wallpapers/app/utils/toast.dart';
import 'package:get/get.dart';
import 'package:wallpaper_manager_flutter/wallpaper_manager_flutter.dart';

class DetailController extends GetxController {
  final imageUrl = "".obs;
  final isLoading = false.obs;
  final homeC = Get.find<HomeController>();
  List<int>? imagePath;

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

  Future<void> shareImage() async {
    try {
      await getImage();
      final temp = await getTemporaryDirectory();
      final path = '${temp.path}/image.jpg';
      File(path).writeAsBytesSync(imagePath!);
      await Share.shareXFiles([XFile(path)], text: 'Image Shared').whenComplete(
        () => homeC.showInterstitial(),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> saveNetworkImage() async {
    var status = await Permission.storage.status;
    if (status.isPermanentlyDenied || status.isRestricted) {
      openAppSettings();
    } else {
      await getImage();
      await ImageGallerySaver.saveImage(
        Uint8List.fromList(imagePath!),
        quality: 100,
        name: "homey",
      );
      var d = Get.snackbar("Success", "Image Saved!",
          backgroundColor: Colors.amber);
      d.close().then((_) => homeC.showInterstitial());
    }
  }

  Future<void> getImage() async {
    if (imagePath == null) {
      Get.dialog(
        Center(
          child: Container(
            padding: const EdgeInsets.all(50),
            color: Colors.white,
            child: const CircularProgressIndicator(),
          ),
        ),
        name: "Loading . . .",
        barrierDismissible: false,
      );
      var response = await Dio().get(
        imageUrl.value,
        options: Options(responseType: ResponseType.bytes),
      );
      imagePath = response.data;
      Get.back();
    }
  }
}
