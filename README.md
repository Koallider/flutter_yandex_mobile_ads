# Flutter plugin for Yandex Mobile Ads SDK

This plugin supports Interstitial and Rewarded Video ads for Android and iOS.

## Installation

To instrument your flutter based mobile application with Yandex Mobile Ads Plugin, add this to your package's pubspec.yaml file:

```yaml
dependencies:
  ...
  flutter_yandex_mobile_ads: 0.0.3
```

# Usage:

## Init
```dart
Yandex.initialize();
```

## Interstitial Ad

### Load
```dart
listener(YandexAdEvent event, dynamic args) {
  if (event == YandexAdEvent.adReady) {
     interstitialLoaded = true;
  } else if (event == YandexAdEvent.adLoadFailed) {
     debugPrint("Failed to load Interstitial Ad");
  }
}

Yandex.interstititalListener = listener;
Yandex.loadInterstitial("R-M-DEMO-interstitial");
```

Replace "R-M-DEMO-interstitial" with your placement key.

### Show
```dart
Yandex.showInterstitial();
```

## Rewarded Video Ad

### Load and Show
```dart
var listener = (YandexAdEvent event, dynamic args) {
  if (event == YandexAdEvent.adReady) {
    Yandex.showRewardedVideo();
  } else if (event == YandexAdEvent.adLoadFailed) {
    debugPrint("Failed to load Rewarded Video");
  } else if (event == YandexAdEvent.adRewarded) {
    debugPrint("Successfully rewarded");
  }
};
Yandex.rewardedListener = listener;
Yandex.loadRewarded("R-M-DEMO-rewarded-client-side-rtb");
```
Replace "R-M-DEMO-rewarded-client-side-rtb" with your placement key.
