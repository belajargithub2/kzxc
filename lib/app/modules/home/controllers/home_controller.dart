import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:wallpapers/app/data/admob.dart';
import 'package:wallpapers/app/modules/home/models/image_model.dart';
import 'package:wallpapers/app/modules/home/providers/wall_provider.dart';
import 'package:wallpapers/app/routes/app_pages.dart';
import 'package:wallpapers/app/utils/settings.dart';
import 'package:wallpapers/app/utils/toast.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class HomeController extends GetxController {
  final isSearch = false.obs;
  final focusNode = FocusNode();
  late String keyword = search;
  final page = 1.obs;
  final pageSize = 10;
  final PagingController<int, Images> pagingController =
      PagingController(firstPageKey: 0);
  final wallProvider = Get.find<WallProvider>();
  final related = <String>[].obs;

  // admon setting
  final db = FirebaseDatabase.instance;
  BannerAd? banner;
  InterstitialAd? interstitial;
  int cc = 0;
  final bannerLoaded = false.obs;

  @override
  void onInit() async {
    super.onInit();
    await _banner();
    await _interstitial();
    _fetchPage(keyword, page.value);
    //data
    pagingController.addPageRequestListener((pageKey) {
      _fetchPage(keyword, pageKey);
    });
  }

  Future<void> _fetchPage(String keyword, int pageKey) async {
    try {
      final newItems = await wallProvider.findWall(keyword, pageKey);
      related(newItems.related);
      final isLastPage = newItems.images!.length < pageSize;
      if (isLastPage) {
        pagingController.appendLastPage(newItems.images!);
      } else {
        final nextPageKey = pageKey + newItems.images!.length ~/ 10;
        pagingController.appendPage(newItems.images!, nextPageKey);
      }
    } catch (_) {
      pagingController.itemList = [];
    }
  }

  Widget customSearchBar() {
    if (isSearch.isTrue) {
      focusNode.requestFocus();
      return TextField(
        focusNode: focusNode,
        textInputAction: TextInputAction.done,
        onSubmitted: (value) {
          showInterstitial();
          keyword = value;
          pagingController.refresh();
          isSearch(false);
        },
        decoration: const InputDecoration(
          hintText: 'Search Wallpaper...',
          hintStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontStyle: FontStyle.italic,
          ),
          border: InputBorder.none,
        ),
        style: const TextStyle(
          color: Colors.white,
        ),
      );
    } else {
      focusNode.unfocus();
      return Text(
        appName,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      );
    }
  }

  void goToDetail(String url) {
    showInterstitial();
    if (url.contains('base64')) {
      warningToast("Wallpaper under maintain");
    } else {
      Get.toNamed(Routes.DETAIL, arguments: url);
    }
  }

  @override
  void dispose() {
    banner?.dispose();
    interstitial?.dispose();
    printInfo(info: 'dispose');
    super.dispose();
  }

  /* BANNER AD */
  Future<void> _banner() async {
    banner = BannerAd(
      adUnitId: Admob.getBannerId(),
      size: AdSize.banner,
      request: AdRequest(keywords: Admob.geyKeyword()),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          bannerLoaded(true);
          printInfo(info: 'AD LOAD');
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          Future.delayed(const Duration(seconds: 10), () {
            _banner();
          });
          bannerLoaded(false);
          printInfo(info: 'Ad failed to load: $error');
        },
        onAdOpened: (Ad ad) {
          printInfo(info: 'Ad opened.');
        },
        onAdClosed: (Ad ad) {
          printInfo(info: 'Ad closed.');
        },
        onAdImpression: (Ad ad) {
          printInfo(info: 'Ad impression.');
        },
      ),
    );
    await banner?.load();
  }

  AdWidget getBanner() {
    return AdWidget(ad: banner!);
  }

  /* INTERSTITIAL AD */
  Future<void> _interstitial() async {
    await InterstitialAd.load(
      adUnitId: Admob.getInterstitialId(),
      request: AdRequest(keywords: Admob.geyKeyword()),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          // Keep a reference to the ad so you can show it later.
          interstitial = ad;
          _interstitialCallback(ad);
          printInfo(info: 'Interstitial loaded');
        },
        onAdFailedToLoad: (LoadAdError error) {
          Future.delayed(const Duration(seconds: 10), () {
            _interstitial();
          });
          printInfo(info: 'InterstitialAd failed to load: $error');
        },
      ),
    );
  }

  void _interstitialCallback(InterstitialAd i) {
    i.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) {
        interstitial = ad;
        printInfo(info: '$ad onAdShowedFullScreenContent.');
      },
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        printInfo(info: '$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _interstitial();
        cc = 0;
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        printInfo(info: '$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _interstitial();
      },
      onAdImpression: (InterstitialAd ad) {
        interstitial = ad;
        printInfo(info: '$ad impression occurred.');
      },
    );
  }

  Future<void> showInterstitial() async {
    if (cc >= 2) {
      interstitial?.show();
    } else {
      cc++;
    }
  }
}
