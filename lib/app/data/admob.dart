import 'package:flutter/foundation.dart';
import 'package:wallpapers/app/data/randoms.dart';

class Admob {
  static List<String> banners = [
    'ca-app-pub-2024732515687909/8569305251',
  ];
  static List<String> interstitials = [
    'ca-app-pub-2024732515687909/6865341342',
  ];

  static String getBannerId() {
    return kDebugMode
        ? 'ca-app-pub-3940256099942544/6300978111'
        : banners.adsId();
  }

  static String getInterstitialId() {
    return kDebugMode
        ? 'ca-app-pub-3940256099942544/1033173712'
        : interstitials.adsId();
  }

  static List<String> geyKeyword() {
    return [
      'insurance',
      'mesothelioma',
      'car crash',
    ];
  }
}
