import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWithFlag {
  bool loaded;
  BannerAd ad;

  BannerAdWithFlag(this.loaded, this.ad);
}

class AdProvider with ChangeNotifier {
  static const _androidAppID = "ca-app-pub-7786369819729095~5789120325";
  static const _iosAppID = "ca-app-pub-7786369819729095~4831261879";
  static const _androidInterstitialID = "ca-app-pub-7786369819729095/1849875317";
  static const _iosInterstitialID = "ca-app-pub-7786369819729095/3518180204";

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    print("Initializing AdProvider");
    _isInitialized = true;
    notifyListeners();
  }


}