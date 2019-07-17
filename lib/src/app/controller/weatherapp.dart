///
/// Copyright (C) 2019 Andrious Solutions
///
/// This program is free software; you can redistribute it and/or
/// modify it under the terms of the GNU General Public License
/// as published by the Free Software Foundation; either version 3
/// of the License, or any later version.
///
/// You may obtain a copy of the License at
///
///  http://www.apache.org/licenses/LICENSE-2.0
///
///
/// Unless required by applicable law or agreed to in writing, software
/// distributed under the License is distributed on an "AS IS" BASIS,
/// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
/// See the License for the specific language governing permissions and
/// limitations under the License.
///
///          Created  22 Feb 2019
///
///

import 'package:weathercast/src/controller.dart'
    show Ads, AppController, Platform, ThemeCon;

import 'package:weathercast/src/home/view/drawer/weather_locations/mvc.dart'
    show LocationCon, LocationMod, LocationTimer;

import 'package:firebase_admob/firebase_admob.dart';

class WeatherApp extends AppController {
  factory WeatherApp() {
    _this ??= WeatherApp._();
    return _this;
  }
  static WeatherApp _this;
  Ads _ads;

  WeatherApp._() : super(){
    _ads = Ads(
      Platform.isAndroid
          ? 'ca-app-pub-3940256099942544~3347511713'
          : 'ca-app-pub-3940256099942544~1458002511',
      bannerUnitId: Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/6300978111'
          : 'ca-app-pub-3940256099942544/2934735716',
      screenUnitId: Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/1033173712'
          : 'ca-app-pub-3940256099942544/4411468910',
      videoUnitId: Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/5224354917'
          : 'ca-app-pub-3940256099942544/1712485313',
      keywords: <String>['weather', 'weather forecast'],
      contentUrl: 'http://www.weathernetwork.com',
      testing: false,
    );
  }

  @override
  void initApp() {
    stateMVC.add(ThemeCon());
  }

  @override
  Future<bool> init() async {
    bool init = await super.init();
    if (init) init = await LocationCon().init();
    if (init) init = await LocationTimer.init();
    return init;
  }

  @override
  void initState() {
    super.initState();
    _ads.showBannerAd(state: this.stateMVC);
  }

  void dispose() {
    /// Close the Location database.
    LocationMod.dispose();
    _ads.dispose();
    super.dispose();
  }
}

class FireBaseAds {

  MobileAdTargetingInfo targetingInfo;
  BannerAd myBanner;
  InterstitialAd myInterstitial;

  FireBaseAds() {

    targetingInfo = MobileAdTargetingInfo(
      keywords: <String>['flutterio', 'beautiful apps'],
      contentUrl: 'https://flutter.io',
      childDirected: false,
      // or MobileAdGender.female, MobileAdGender.unknown
      testDevices: <String>[], // Android emulators are considered test devices
    );

    myBanner = BannerAd(
      // Replace the testAdUnitId with an ad unit id from the AdMob dash.
      // https://developers.google.com/admob/android/test-ads
      // https://developers.google.com/admob/ios/test-ads
      adUnitId: BannerAd.testAdUnitId,
      size: AdSize.smartBanner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event is $event");
      },
    );

    myInterstitial = InterstitialAd(
      // Replace the testAdUnitId with an ad unit id from the AdMob dash.
      // https://developers.google.com/admob/android/test-ads
      // https://developers.google.com/admob/ios/test-ads
      adUnitId: InterstitialAd.testAdUnitId,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("InterstitialAd event is $event");
      },
    );
  }
}
