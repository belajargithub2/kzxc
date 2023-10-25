import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:upgrader/upgrader.dart';
import 'package:wallpapers/app/modules/home/controllers/home_controller.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:wallpapers/app/modules/home/models/picture_model.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      upgrader: Upgrader(
        showIgnore: false,
        showLater: false,
        showReleaseNotes: false,
        shouldPopScope: () => false,
        dialogStyle: UpgradeDialogStyle.cupertino,
        minAppVersion: '6.2.1',
        messages: UpgraderMessages(code: 'en'),
      ),
      child: _body(),
    );
  }

  Widget _body() {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          leading: controller.isSearch.isTrue ? const Icon(Icons.search) : null,
          title: controller.customSearchBar(),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () => controller.isSearch.toggle(),
              icon: Icon(
                  controller.isSearch.isTrue ? Icons.cancel : Icons.search),
            )
          ],
          centerTitle: true,
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: controller.related.isEmpty ? 0 : 30,
              margin: const EdgeInsets.all(5),
              child: ListView.separated(
                itemBuilder: (_, i) => _related(controller.related[i]),
                separatorBuilder: (_, __) => const SizedBox(width: 5),
                itemCount: controller.related.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
              ),
            ),
            _banner(),
            Expanded(
              child: PagedGridView<int, Images>(
                shrinkWrap: true,
                pagingController: controller.pagingController,
                physics: const BouncingScrollPhysics(),
                gridDelegate: SliverQuiltedGridDelegate(
                  crossAxisCount: 4,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  repeatPattern: QuiltedGridRepeatPattern.inverted,
                  pattern: const [
                    QuiltedGridTile(4, 2),
                    QuiltedGridTile(1, 1),
                    QuiltedGridTile(1, 1),
                    QuiltedGridTile(3, 2),
                  ],
                ),
                builderDelegate: PagedChildBuilderDelegate<Images>(
                  itemBuilder: (context, item, index) => Material(
                    child: InkWell(
                      onTap: () {
                        controller.goToDetail("${item.url}");
                      },
                      child: CachedNetworkImage(
                        imageUrl: "${item.url}",
                        fit: BoxFit.cover,
                        placeholder: (_, __) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (_, __, ___) => const Icon(Icons.warning),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _related(String text) {
    return ElevatedButton(
        onPressed: () {
          controller.showInterstitial();
          controller.keyword = text;
          controller.pagingController.refresh();
        },
        child: Text(text));
  }

  Widget _banner() {
    return Obx(
      () {
        return controller.getBanner();
      },
    );
  }
}
