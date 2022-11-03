import 'dart:async';

import 'package:flutter/services.dart';
import 'yandex_consts.dart';

///List of possible Ad events
enum YandexAdEvent {
  ///Ad is displayed
  adOpened,

  ///Ad was cloased
  adClosed,

  ///Reward can be given to the user
  adRewarded,

  ///Ad impression was counted
  adImpressionCounted,

  ///Detected a click on the Ad
  adClicked,

  ///Ad is ready to be shown
  adReady,

  ///Failed to load Ad.
  ///Use arguments['errorCode'] to get the error code from SDK]
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

  ///Initializes the SDK
  ///
  /// Call this on the start of your application.
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

  /// Loads an Interstitial Ad.
  ///
  /// Set [interstititalListener] to track loading and display events
  /// for the Interstitial Ad.
  ///
  /// Ad is ready to be shown when [adReady] event is received.
  ///
  /// Args:
  ///   [placementId] (String): The placement ID of the interstitial ad.
  static Future<dynamic> loadInterstitial(String placementId) async {
    await _channel
        .invokeMethod('loadInterstitial', {'placementId': placementId});
  }

  /// Shows an Interstitial Ad.
  ///
  /// Before showing the Ad, call [loadInterstitial] and wait for the
  /// [adReady] event.
  static Future<dynamic> showInterstitial() async {
    await _channel.invokeMethod('showInterstitial');
  }

  /// Loads a Rewarded Video Ad.
  ///
  /// Set [rewardedListener] to track loading and display events
  /// for the Rewarded Video Ad.
  ///
  /// Ad is ready to be shown when [adReady] event is received.
  /// Give a reward to the user when [adRewarded] event is received.
  ///
  /// Args:
  ///   [placementId] (String): The placement ID of the interstitial ad.
  static Future<dynamic> loadRewarded(String placementId) async {
    await _channel
        .invokeMethod('loadRewardedVideo', {'placementId': placementId});
  }

  /// Shows a Rewarded Video Ad.
  ///
  /// Before showing the Ad, call [loadRewarded] and wait for the
  /// [adReady] event.
  static Future<dynamic> showRewardedVideo() async {
    await _channel.invokeMethod('showRewardedVideo');
  }

  /// A map of the Rewarded Video Ad events that can be received from the native SDK.
  static final Map<String, YandexAdEvent> _rewardedEventMap = {
    ON_REWARDED_VIDEO_AD_CLICKED: YandexAdEvent.adClicked,
    ON_REWARDED_VIDEO_AD_CLOSED: YandexAdEvent.adClosed,
    ON_REWARDED_VIDEO_AD_OPENED: YandexAdEvent.adOpened,
    ON_REWARDED_VIDEO_AD_REWARDED: YandexAdEvent.adRewarded,
    ON_REWARDED_VIDEO_IMPRESSION_COUNTED: YandexAdEvent.adImpressionCounted,
    ON_REWARDED_AD_READY: YandexAdEvent.adReady,
    ON_REWARDED_AD_LOAD_FAILED: YandexAdEvent.adLoadFailed,
  };

  /// A map of the Interstitial Ad events that can be received from the native SDK.
  static final Map<String, YandexAdEvent> _interstitialEventMap = {
    ON_INTERSTITIAL_AD_CLICKED: YandexAdEvent.adClicked,
    ON_INTERSTITIAL_AD_CLOSED: YandexAdEvent.adClosed,
    ON_INTERSTITIAL_AD_OPENED: YandexAdEvent.adOpened,
    ON_INTERSTITIAL_AD_READY: YandexAdEvent.adReady,
    ON_INTERSTITIAL_AD_IMPRESSION_COUNTED: YandexAdEvent.adImpressionCounted,
    ON_INTERSTITIAL_AD_LOAD_FAILED: YandexAdEvent.adLoadFailed,
  };

  static Future<dynamic> _handle(MethodCall call) async {
    if (_rewardedEventMap.containsKey(call.method)) {
      _rewardedListener?.call(_rewardedEventMap[call.method]!, call.arguments);
    } else if (_interstitialEventMap.containsKey(call.method)) {
      _interstititalListener?.call(
          _interstitialEventMap[call.method]!, call.arguments);
    }
  }
}
