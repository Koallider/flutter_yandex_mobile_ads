package me.koallider.flutter_yandex_mobile_ads

object YandexConsts {
    const val MAIN_CHANNEL = "me.koallider.flutter_yandex_mobile_ads"
    const val BANNER_CHANNEL = "$MAIN_CHANNEL/banner"
    const val INIT = "initialize"
    const val LOAD_INTERSTITIAL = "loadInterstitial"
    const val SHOW_INTERSTITIAL = "showInterstitial"
    const val LOAD_REWARDED = "loadRewardedVideo"
    const val SHOW_REWARDED_VIDEO = "showRewardedVideo"
    const val LOAD_BANNER = "loadBanner"
    const val REPORT_SIZE = "reportSize"

    // Rewarded keys
    const val ON_REWARDED_VIDEO_AD_OPENED = "onRewardedVideoAdOpened"
    const val ON_REWARDED_VIDEO_AD_CLOSED = "onRewardedVideoAdClosed"
    const val ON_REWARDED_VIDEO_IMPRESSION_COUNTED = "onRewardedVideoImpressionCounted"
    const val ON_REWARDED_VIDEO_AD_REWARDED = "onRewardedVideoAdRewarded"
    const val ON_REWARDED_VIDEO_AD_CLICKED = "onRewardedVideoAdClicked"
    const val ON_REWARDED_AD_READY = "onRewardedAdReady"
    const val ON_REWARDED_AD_LOAD_FAILED = "onRewardedAdLoadFailed"
    const val ON_REWARDED_AD_SHOW_FAILED = "onRewardedAdShowFailed"

    //  Interstitial keys
    const val ON_INTERSTITIAL_AD_OPENED = "onInterstitialAdOpened"
    const val ON_INTERSTITIAL_AD_READY = "onInterstitialAdReady"
    const val ON_INTERSTITIAL_AD_CLOSED = "onInterstitialAdClosed"
    const val ON_INTERSTITIAL_AD_LOAD_FAILED = "onInterstitialAdLoadFailed"
    const val ON_INTERSTITIAL_AD_SHOW_FAILED = "onInterstitialAdShowFailed"
    const val ON_INTERSTITIAL_AD_IMPRESSION_COUNTED = "onInterstitialAdImpressionCounted"
    const val ON_INTERSTITIAL_AD_CLICKED = "onInterstitialAdClicked"

    //Banner Keys
    const val ON_BANNER_AD_LOADED = "onBannerAdLoaded";
    const val ON_BANNER_AD_LOAD_FAILED = "onBannerAdLoadFailed";
    const val ON_BANNER_AD_CLICKED = "onBannerAdClicked"
    const val ON_BANNER_AD_IMPRESSION_COUNTED = "onBannerAdImpressionCounted"
}