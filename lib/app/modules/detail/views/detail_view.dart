import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/detail_controller.dart';

class DetailView extends GetView<DetailController> {
  const DetailView({Key? key}) : super(key: key);
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
          Container(
            margin: const EdgeInsets.all(50),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(20),
            ),
            child: InkWell(
              onTap: () => controller.showDialog(),
              child: const Text(
                "Apply",
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
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
