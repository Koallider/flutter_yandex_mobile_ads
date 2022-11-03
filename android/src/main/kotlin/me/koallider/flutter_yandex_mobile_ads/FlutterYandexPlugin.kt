package me.koallider.flutter_yandex_mobile_ads

import android.app.Activity
import android.os.Bundle
import android.util.Log
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import java.util.*
import me.koallider.flutter_yandex_mobile_ads.YandexConsts
import com.yandex.mobile.ads.common.*
import com.yandex.mobile.ads.interstitial.InterstitialAd
import com.yandex.mobile.ads.interstitial.InterstitialAdEventListener
import com.yandex.mobile.ads.rewarded.Reward
import com.yandex.mobile.ads.rewarded.RewardedAd
import com.yandex.mobile.ads.rewarded.RewardedAdEventListener


/** FlutterYandexPlugin */
class FlutterYandexPlugin() : FlutterPlugin, MethodCallHandler, ActivityAware {
    private lateinit var mActivity: Activity
    private lateinit var mChannel: MethodChannel
    private lateinit var messenger: BinaryMessenger
    private lateinit var flutterPluginBinding: FlutterPlugin.FlutterPluginBinding

    private var mInterstitialAd: InterstitialAd? = null
    private var mRewardedAd: RewardedAd? = null

    val TAG = "FLutterYandexMobileAds"

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == YandexConsts.INIT) {
            initialize()
            result.success(null)
        } else if (call.method == YandexConsts.LOAD_INTERSTITIAL) {
            loadInterstitial(call.argument<String?>("placementId")!!)
            result.success(null)
        } else if (call.method == YandexConsts.SHOW_INTERSTITIAL) {
            showInterstitial()
            result.success(null)
        } else if (call.method == YandexConsts.LOAD_REWARDED) {
            loadRewarded(call.argument<String?>("placementId")!!)
            result.success(null)
        } else if (call.method == YandexConsts.SHOW_REWARDED_VIDEO) {
            showRewarded()
            result.success(null)
        } else {
            result.notImplemented()
        }
    }

    fun initialize() {
        MobileAds.initialize(
            mActivity
        ) { Log.d(TAG, "SDK initialized") }
    }

    fun loadInterstitial(placementId: String) {
        mInterstitialAd = InterstitialAd(mActivity)
        mInterstitialAd!!.setAdUnitId(placementId)

        val adRequest = AdRequest.Builder().build()
        mInterstitialAd!!.setInterstitialAdEventListener(object : InterstitialAdEventListener {
            override fun onAdLoaded() {
                mActivity.runOnUiThread {
                    val arguments = HashMap<String, Any>()
                    mChannel.invokeMethod(YandexConsts.ON_INTERSTITIAL_AD_READY, arguments)
                }
                Log.d(TAG, "onAdLoaded")
            }

            override fun onAdFailedToLoad(error: AdRequestError) {
                mActivity.runOnUiThread {
                    val arguments = HashMap<String, Any>()
                    arguments["errorCode"] = error.code
                    arguments["errorMessage"] = "FAILED TO LOAD"
                    mChannel.invokeMethod(YandexConsts.ON_INTERSTITIAL_AD_LOAD_FAILED, arguments)
                }
                Log.d(TAG, "onAdFailedToLoad")
            }

            override fun onAdShown() {
                mActivity.runOnUiThread {
                    val arguments = HashMap<String, Any>()
                    mChannel.invokeMethod(YandexConsts.ON_INTERSTITIAL_AD_OPENED, arguments)
                }
                Log.d(TAG, "onAdShown")
            }

            override fun onAdDismissed() {
                mActivity.runOnUiThread {
                    val arguments = HashMap<String, Any>()
                    mChannel.invokeMethod(YandexConsts.ON_INTERSTITIAL_AD_CLOSED, arguments)
                }
                Log.d(TAG, "onAdDismissed")
            }

            override fun onAdClicked() {
                mActivity.runOnUiThread {
                    val arguments = HashMap<String, Any>()
                    mChannel.invokeMethod(YandexConsts.ON_INTERSTITIAL_AD_CLICKED, arguments)
                }
                Log.d(TAG, "onAdClicked")
            }

            override fun onLeftApplication() {
                Log.d(TAG, "onLeftApplication")
            }

            override fun onReturnedToApplication() {
                Log.d(TAG, "onReturnedToApplication")
            }

            override fun onImpression(p0: ImpressionData?) {
                mActivity.runOnUiThread {
                    val arguments = HashMap<String, Any>()
                    mChannel.invokeMethod(
                        YandexConsts.ON_INTERSTITIAL_AD_IMPRESSION_COUNTED,
                        arguments
                    )
                }
                Log.d(TAG, "onImpression")
            }

        })
        mInterstitialAd!!.loadAd(adRequest)
    }

    fun showInterstitial() {
        if (mInterstitialAd?.isLoaded == true) {
            mInterstitialAd?.show()
        }
    }

    fun loadRewarded(placementId: String) {
        mRewardedAd = RewardedAd(mActivity)
        mRewardedAd!!.setAdUnitId(placementId)

        val adRequest = AdRequest.Builder().build()
        mRewardedAd!!.setRewardedAdEventListener(object : RewardedAdEventListener {
            override fun onAdLoaded() {
                mActivity.runOnUiThread {
                    val arguments = HashMap<String, Any>()
                    mChannel.invokeMethod(YandexConsts.ON_REWARDED_AD_READY, arguments)
                }
                Log.d(TAG, "onAdLoaded")
            }

            override fun onAdFailedToLoad(error: AdRequestError) {
                mActivity.runOnUiThread {
                    val arguments = HashMap<String, Any>()
                    arguments["errorCode"] = error.code
                    arguments["errorMessage"] = "FAILED TO LOAD"
                    mChannel.invokeMethod(YandexConsts.ON_REWARDED_AD_LOAD_FAILED, arguments)
                }
                Log.d(TAG, "onAdFailedToLoad")
            }

            override fun onAdShown() {
                mActivity.runOnUiThread {
                    val arguments = HashMap<String, Any>()
                    mChannel.invokeMethod(YandexConsts.ON_REWARDED_VIDEO_AD_OPENED, arguments)
                }
                Log.d(TAG, "onAdShown")
            }

            override fun onAdDismissed() {
                mActivity.runOnUiThread { //back on UI threa
                    val arguments = HashMap<String, Any>()
                    mChannel.invokeMethod(YandexConsts.ON_REWARDED_VIDEO_AD_CLOSED, arguments)
                }
                Log.d(TAG, "onAdDismissed")
            }

            override fun onRewarded(p0: Reward) {
                mActivity.runOnUiThread {
                    val arguments = HashMap<String, Any>()
                    mChannel.invokeMethod(YandexConsts.ON_REWARDED_VIDEO_AD_REWARDED, arguments)
                }
            }

            override fun onAdClicked() {
                mActivity.runOnUiThread {
                    val arguments = HashMap<String, Any>()
                    mChannel.invokeMethod(YandexConsts.ON_REWARDED_VIDEO_AD_CLICKED, arguments)
                }
                Log.d(TAG, "onAdClicked")
            }

            override fun onLeftApplication() {
                Log.d(TAG, "onLeftApplication")

            }

            override fun onReturnedToApplication() {
                Log.d(TAG, "onReturnedToApplication")
            }

            override fun onImpression(p0: ImpressionData?) {
                mActivity.runOnUiThread {
                    val arguments = HashMap<String, Any>()
                    mChannel.invokeMethod(
                        YandexConsts.ON_REWARDED_VIDEO_IMPRESSION_COUNTED,
                        arguments
                    )
                }
                Log.d(TAG, "onImpression")
            }

        })
        mRewardedAd!!.loadAd(adRequest)
    }

    fun showRewarded() {
        if (mRewardedAd?.isLoaded == true) {
            mRewardedAd?.show()
        }
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        this.flutterPluginBinding = binding
        this.mChannel = MethodChannel(binding.binaryMessenger, YandexConsts.MAIN_CHANNEL)
        this.mChannel.setMethodCallHandler(this)
        Log.i("DEBUG", "Tesst On Attached")
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        this.mChannel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        this.mActivity = binding.activity;
        Log.i("DEBUG", "Tesst On Activity")
    }

    override fun onDetachedFromActivityForConfigChanges() {
        //("Not yet implemented")
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        //("Not yet implemented")
    }

    override fun onDetachedFromActivity() {
        //("Not yet implemented")
    }
}
