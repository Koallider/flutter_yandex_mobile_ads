import 'dart:async';

import 'package:flutter/services.dart';
import 'yandex_consts.dart';
import 'package:flutter/material.dart';

enum YandexAdEvent {
  adOpened,
  adClosed,
  adStarted,
  adRewarded,
  adShown,
  adClicked,
  adReady,
  adLoadFailed
}

typedef YandexAdListener(YandexAdEvent event, dynamic arguments);

class Yandex {
  static const MethodChannel _channel =
      MethodChannel("me.koallider.flutter_yandex_mobile_ads");
  static YandexAdListener? _rewardedListener;
  static YandexAdListener? _interstititalListener;


  static set rewardedListener(YandexAdListener value) {
    _rewardedListener = value;
  }

  static set interstititalListener(YandexAdListener value) {
    _interstititalListener = value;
  }

  static FutureOr<dynamic> initialize(
      {final String? appKey,
      bool gdprConsent = true,
      bool ccpaConsent = true}) async {
    _channel.setMethodCallHandler(_handle);
    await _channel.invokeMethod('initialize', {
      'appKey': appKey,
      'gdprConsent': gdprConsent,
      'ccpaConsent': ccpaConsent
    });
  }

  //interstitial
  static Future<dynamic> loadInterstitial(String placementId) async {
    await _channel.invokeMethod('loadInterstitial', {'placementId': placementId});
  }

  static Future<dynamic> showInterstitial() async {
    await _channel.invokeMethod('showInterstitial');
  }

  //rewarded
  static Future<dynamic> loadRewarded(String placementId) async {
    await _channel.invokeMethod('loadRewardedVideo', {'placementId': placementId});
  }

  static Future<dynamic> showRewardedVideo() async {
    await _channel.invokeMethod('showRewardedVideo');
  }

  static Future<dynamic> activityResumed() async {
    await _channel.invokeMethod('activityResumed');
  }

  static Future<dynamic> activityPaused() async {
    await _channel.invokeMethod('activityPaused');
  }

  static final Map<String, YandexAdEvent> rewardedEventMap = {
    ON_REWARDED_VIDEO_AD_CLICKED: YandexAdEvent.adClicked,
    ON_REWARDED_VIDEO_AD_CLOSED: YandexAdEvent.adClosed,
    ON_REWARDED_VIDEO_AD_OPENED: YandexAdEvent.adOpened,
    ON_REWARDED_VIDEO_AD_REWARDED: YandexAdEvent.adRewarded,
    ON_REWARDED_VIDEO_AD_STARTED: YandexAdEvent.adStarted,
    ON_REWARDED_AD_READY: YandexAdEvent.adReady,
    ON_REWARDED_AD_LOAD_FAILED: YandexAdEvent.adLoadFailed,
  };

  static final Map<String, YandexAdEvent> interstitialEventMap = {
    ON_INTERSTITIAL_AD_CLICKED: YandexAdEvent.adClicked,
    ON_INTERSTITIAL_AD_CLOSED: YandexAdEvent.adClosed,
    ON_INTERSTITIAL_AD_OPENED: YandexAdEvent.adOpened,
    ON_INTERSTITIAL_AD_READY: YandexAdEvent.adReady,
    ON_INTERSTITIAL_AD_SHOW_SUCCEEDED: YandexAdEvent.adShown,
    ON_INTERSTITIAL_AD_LOAD_FAILED: YandexAdEvent.adLoadFailed,
  };

  static Future<dynamic> _handle(MethodCall call) async {
    debugPrint("REWARD INTERSTITIAL: ${call.method}");
    if(rewardedEventMap.containsKey(call.method)) {
      _rewardedListener?.call(
          rewardedEventMap[call.method]!, call.arguments);
    }else if(interstitialEventMap.containsKey(call.method)){
      _interstititalListener?.call(
          interstitialEventMap[call.method]!, call.arguments);
    }
  }
}
