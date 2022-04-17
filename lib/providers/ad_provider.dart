import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWithFlag {
  bool loaded;
  BannerAd ad;

  BannerAdWithFlag(this.loaded, this.ad);
}

class AdProvider with ChangeNotifier {
  static const _androidBannerID = "ca-app-pub-7786369819729095/7888478827";
  static const _iOSBannerID = "ca-app-pub-7786369819729095/5262315480";

  // test ads
  //static const _androidBannerID = "ca-app-pub-3940256099942544/6300978111";

  late List<BannerAdWithFlag> _bannerAds;
  bool _isInitialized = false;
  int _bannerCount = -1;

  String get bannerID => Platform.isAndroid ? _androidBannerID : _iOSBannerID;

  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    print("Initializing AdProvider");
    _bannerAds = List.empty(growable: true);
    for (int i = 0; i < 10; ++i) {
      _bannerAds.add(BannerAdWithFlag(
          false,
          BannerAd(
            adUnitId: bannerID,
            size: AdSize.banner,
            request: const AdRequest(),
            listener: BannerAdListener(onAdLoaded: (ad) {
              adLoaded(ad, i);
            }),
          )));
      await _bannerAds[i].ad.load();
    }

    _isInitialized = true;
    notifyListeners();
  }

  //region Banner Ad Functions
  void adLoaded(Ad ad, int index) {
    _bannerAds[index].loaded = true;
  }

  Widget bannerWidget() {
    if (!isInitialized) return const SizedBox(height: 50);
    ++_bannerCount;
    if (_bannerCount >= _bannerAds.length || !_bannerAds[_bannerCount].loaded) {
      return const SizedBox.shrink();
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Container(
            alignment: Alignment.center,
            child: AdWidget(
              ad: _bannerAds[_bannerCount].ad,
            ),
            width: _bannerAds[_bannerCount].ad.size.width.toDouble(),
            height: 50),
      ),
    );
  }

//endregion
}