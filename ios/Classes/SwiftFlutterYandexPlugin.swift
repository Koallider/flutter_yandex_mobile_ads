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
            channel.invokeMethod("onInterstitialAdImpressionCounted", arguments: nil)
        }

        func interstitialAdWillLeaveApplication(_ interstitialAd: YMAInterstitialAd) {
        }

        func interstitialAdDidFail(toPresent interstitialAd: YMAInterstitialAd, error: Error) {
        }

        func interstitialAdWillAppear(_ interstitialAd: YMAInterstitialAd) {

        }

        func interstitialAdDidAppear(_ interstitialAd: YMAInterstitialAd) {
            channel.invokeMethod("onInterstitialAdOpened", arguments: nil)
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
            channel.invokeMethod("onRewardedVideoImpressionCounted", arguments: nil)
        }
        
        func rewardedAdWillLeaveApplication(_ rewardedAd: YMARewardedAd) {
        }
        
        func rewardedAdDidFail(toPresent rewardedAd: YMARewardedAd, error: Error) {
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
        
        let factory = YandexBannerViewFactory(messenger: registrar.messenger())
        registrar.register(factory, withId: "me.koallider.flutter_yandex_mobile_ads/banner")
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

class YandexBannerViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return YandexBannnerView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger)
    }
    
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
          return FlutterStandardMessageCodec.sharedInstance()
    }
}

class YandexBannnerView: NSObject, FlutterPlatformView, YMAAdViewDelegate {
    private var _view: UIView
    private var adView: YMAAdView!
    
    private var channel: FlutterMethodChannel
        
    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?
    ) {
        var channelName = "me.koallider.flutter_yandex_mobile_ads/banner\(viewId)"
        channel = FlutterMethodChannel(name: channelName, binaryMessenger: messenger!);
        _view = UIView()
        super.init()
        // iOS views can be created here
        createNativeView(view: _view, arguments: args)
    }

    func view() -> UIView {
        return _view
    }

    func createNativeView(view _view: UIView, arguments args: Any?){
        channel.setMethodCallHandler(handle)
        let argumentsDictionary = args! as! Dictionary<String, Any>
        
        let width = argumentsDictionary["width"] as! Int
        let height = argumentsDictionary["height"] as? Int
        let adSize: YMAAdSize;
        if(height != nil){
            adSize = YMAAdSize.flexibleSize(with: CGSize(width: CGFloat(width), height: CGFloat(height!)))
        }else{
            adSize = YMAAdSize.stickySize(withContainerWidth: CGFloat(width))
        }
        let adUnitId = argumentsDictionary["adUnitId"] as! String
        adView = YMAAdView(adUnitID: adUnitId, adSize: adSize)
        adView.delegate = self
        _view.addSubview(adView)
        adView.translatesAutoresizingMaskIntoConstraints = false
        let adViewConstraints = [
            adView.leadingAnchor.constraint(equalTo: adView.superview!.leadingAnchor),
            adView.trailingAnchor.constraint(equalTo: adView.superview!.trailingAnchor)
        ]
        NSLayoutConstraint.activate(adViewConstraints)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if(call.method == "reportSize"){
            let data = [
                "platformWidth": Int(adView.adContentSize().width),
                "platformHeight": Int(adView.adContentSize().height),
            ]
            result(data)
        } else if(call.method == "loadBanner"){
            adView.loadAd()
            result(true)
        }
    }
    
    func adViewDidLoad(_ adView: YMAAdView) {
        channel.invokeMethod("onBannerAdLoaded", arguments: nil)
    }
    
    func adViewDidFailLoading(_ adView: YMAAdView, error: Error) {
        let data = [
                        "errorCode": "-1",
                        "errorMessage": error.localizedDescription
                    ]
        channel.invokeMethod("onBannerAdLoadFailed", arguments: data)
    }
    
    func adViewDidClick(_ adView: YMAAdView) {
        channel.invokeMethod("onBannerAdClicked", arguments: nil)
    }
    
    func adView(_ adView: YMAAdView, didTrackImpressionWith impressionData: YMAImpressionData?) {
        channel.invokeMethod("onBannerAdImpressionCounted", arguments: nil)
    }
}
