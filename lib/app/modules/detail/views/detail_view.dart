import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallpapers/app/modules/detail/controllers/detail_controller.dart';

class DetailView extends GetView<DetailController> {
  const DetailView({super.key});

  Widget _button({Widget? child, Function()? onClick}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 50),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: onClick,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SizedBox(
            height: double.infinity,
            child: CachedNetworkImage(
              imageUrl: controller.imageUrl.value,
              fit: BoxFit.cover,
              alignment: Alignment.center,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _button(
                onClick: () => controller.shareImage(),
                child: const Icon(
                  Icons.share,
                ),
              ),
              _button(
                onClick: () => controller.showDialog(),
                child: const Text(
                  "Apply",
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
              _button(
                onClick: () => controller.saveNetworkImage(),
                child: const Icon(
                  Icons.save,
                ),
              ),
            ],
          ),
          Obx(() {
            return controller.isLoading.isTrue
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : const SizedBox();
          }),
        ],
      ),
    );
  }
}
