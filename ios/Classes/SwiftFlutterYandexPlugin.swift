import Flutter
import UIKit
import YandexMobileAds

public class SwiftFlutterYandexPlugin: NSObject, FlutterPlugin {

    private static var interstitialDelegate: YMAInterstitialAdDelegate?;
    private static var rewardedDelegate: YMARewardedAdDelegate?;
    
    var interstitialAd: YMAInterstitialAd?
    var rewardedAd: YMARewardedAd?

    class InterstitialDelegate : NSObject, YMAInterstitialAdDelegate{

        var channel: FlutterMethodChannel;

        init(channel: FlutterMethodChannel){
            self.channel = channel;
        }

        func interstitialAdDidLoad(_ interstitialAd: YMAInterstitialAd) {
            channel.invokeMethod("onInterstitialAdReady", arguments: nil)
        }

        func interstitialAdDidFail(toLoad interstitialAd: YMAInterstitialAd, error: Error) {
            let data = [
                            "errorCode": "-1",
                            "errorMessage": error.localizedDescription
                        ]
            channel.invokeMethod("onInterstitialAdLoadFailed", arguments: data)
        }

        func interstitialAdDidClick(_ interstitialAd: YMAInterstitialAd) {
            channel.invokeMethod("onInterstitialAdClicked", arguments: nil)
        }

        func interstitialAd(_ interstitialAd: YMAInterstitialAd, didTrackImpressionWith impressionData: YMAImpressionData?) {
            channel.invokeMethod("onInterstitialAdOpened", arguments: nil)
        }

        func interstitialAdWillLeaveApplication(_ interstitialAd: YMAInterstitialAd) {
            print("Will leave application")
        }

        func interstitialAdDidFail(toPresent interstitialAd: YMAInterstitialAd, error: Error) {
            channel.invokeMethod("onInterstitialAdShowFailed", arguments: nil)
        }

        func interstitialAdWillAppear(_ interstitialAd: YMAInterstitialAd) {

        }

        func interstitialAdDidAppear(_ interstitialAd: YMAInterstitialAd) {
            channel.invokeMethod("onInterstitialAdShowSucceeded", arguments: nil)
        }

        func interstitialAdWillDisappear(_ interstitialAd: YMAInterstitialAd) {

        }

        func interstitialAdDidDisappear(_ interstitialAd: YMAInterstitialAd) {
            channel.invokeMethod("onInterstitialAdClosed", arguments: nil)
        }

        func interstitialAd(_ interstitialAd: YMAInterstitialAd, willPresentScreen webBrowser: UIViewController?) {

        }
    }


    class RewardedDelegate : NSObject, YMARewardedAdDelegate {

        var channel: FlutterMethodChannel;

        init(channel: FlutterMethodChannel){
            self.channel = channel;
        }
        
        func rewardedAd(_ rewardedAd: YMARewardedAd, didReward reward: YMAReward) {
            let data = [
                "placementId": "",
            ]
            channel.invokeMethod("onRewardedVideoAdRewarded", arguments: data)
        }
        
        func rewardedAdDidLoad(_ rewardedAd: YMARewardedAd) {
            channel.invokeMethod("onRewardedAdReady", arguments: nil)
        }
        
        func rewardedAdDidFail(toLoad rewardedAd: YMARewardedAd, error: Error) {
            let data = [
                            "errorCode": "-1",
                            "errorMessage": error.localizedDescription
                        ]
            channel.invokeMethod("onRewardedAdLoadFailed", arguments: data)
        }

        func rewardedAdDidClick(_ rewardedAd: YMARewardedAd) {
            channel.invokeMethod("onRewardedVideoAdClicked", arguments: nil)
        }

        func rewardedAd(_ rewardedAd: YMARewardedAd, didTrackImpressionWith impressionData: YMAImpressionData?) {
            channel.invokeMethod("onRewardedVideoAdStarted", arguments: nil)
        }
        
        func rewardedAdWillLeaveApplication(_ rewardedAd: YMARewardedAd) {
        }
        
        func rewardedAdDidFail(toPresent rewardedAd: YMARewardedAd, error: Error) {
            channel.invokeMethod("onRewardedVideoAdShowFailed", arguments: nil)
        }
        
        func rewardedAdWillAppear(_ rewardedAd: YMARewardedAd) {
        }

        func rewardedAdDidAppear(_ rewardedAd: YMARewardedAd) {
            channel.invokeMethod("onRewardedVideoAdOpened", arguments: nil)
        }
        
        func rewardedAdWillDisappear(_ rewardedAd: YMARewardedAd) {
        }

        func rewardedAdDidDisappear(_ rewardedAd: YMARewardedAd) {
            channel.invokeMethod("onRewardedVideoAdClosed", arguments: nil)
        }
        
        func rewardedAd(_ rewardedAd: YMARewardedAd, willPresentScreen viewController: UIViewController?) {
        }
    }

    var channel: FlutterMethodChannel;
    init(channel: FlutterMethodChannel) {
        self.channel = channel

    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "me.koallider.flutter_yandex_mobile_ads", binaryMessenger: registrar.messenger())


        let instance = SwiftFlutterYandexPlugin(channel: channel)
        registrar.addMethodCallDelegate(instance, channel: channel)

        rewardedDelegate = RewardedDelegate(channel: channel)
        interstitialDelegate = InterstitialDelegate(channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {

        if (call.method == "getPlatformVersion") {
            result("iOS " + UIDevice.current.systemVersion)
        }
        else if (call.method == "loadInterstitial") {
            let myArgs = call.arguments as? [String: Any]
            let placementId = myArgs?["placementId"] as? String ?? ""
            self.interstitialAd = YMAInterstitialAd(adUnitID: placementId)
            self.interstitialAd?.delegate = SwiftFlutterYandexPlugin.interstitialDelegate;
            self.interstitialAd?.load()
        }else if (call.method == "showInterstitial") {
            if let viewController = UIApplication.shared.keyWindow!.rootViewController {
                self.interstitialAd?.present(from: viewController)
            }
        }else if (call.method == "loadRewardedVideo") {
            let myArgs = call.arguments as? [String: Any]
            let placementId = myArgs?["placementId"] as? String ?? ""
            self.rewardedAd = YMARewardedAd(adUnitID: placementId)
            self.rewardedAd?.delegate = SwiftFlutterYandexPlugin.rewardedDelegate;
            self.rewardedAd?.load()
        }else if (call.method == "showRewardedVideo") {
            if let viewController = UIApplication.shared.keyWindow!.rootViewController {
                self.rewardedAd?.present(from: viewController)
            }
        }
        result(true)
    }
}
