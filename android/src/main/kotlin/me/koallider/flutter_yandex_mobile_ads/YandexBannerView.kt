package me.koallider.flutter_yandex_mobile_ads

import android.content.Context
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.view.View
import androidx.annotation.NonNull
import com.yandex.mobile.ads.banner.AdSize
import com.yandex.mobile.ads.banner.BannerAdEventListener
import com.yandex.mobile.ads.banner.BannerAdView
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import java.util.*
import com.yandex.mobile.ads.common.AdRequest
import com.yandex.mobile.ads.common.AdRequestError
import com.yandex.mobile.ads.common.ImpressionData
import io.flutter.plugin.common.MethodCall

class YandexBannerView(
    context: Context,
    id: Int,
    creationParams: Map<String?, Any?>?,
    messenger: BinaryMessenger,
) : PlatformView, MethodChannel.MethodCallHandler {

    val TAG = "FLutterYandexMobileAds"

    private val bannerView: BannerAdView
    private val channel: MethodChannel = MethodChannel(
        messenger, YandexConsts.BANNER_CHANNEL + id
    )

    override fun getView(): View {
        return bannerView
    }

    override fun dispose() {
        channel.setMethodCallHandler(null)
    }

    init {
        channel.setMethodCallHandler(this)
        bannerView = BannerAdView(context)
        bannerView.setAdUnitId(creationParams!!["adUnitId"]!! as String)
        val width = creationParams["width"]!! as Int
        val height = creationParams["height"] as Int?
        if(height == null){
            bannerView.setAdSize(AdSize.stickySize(width))
        }else {
            bannerView.setAdSize(AdSize.flexibleSize(width, height))
        }

        bannerView.setBannerAdEventListener(object : BannerAdEventListener {
            override fun onAdLoaded() {
                Handler(Looper.getMainLooper()).post {
                    val arguments = HashMap<String, Any>()
                    channel.invokeMethod(YandexConsts.ON_BANNER_AD_LOADED, arguments)
                }
            }

            override fun onAdFailedToLoad(error: AdRequestError) {
                Handler(Looper.getMainLooper()).post {
                    val arguments = HashMap<String, Any>()
                    arguments["errorCode"] = error.code
                    arguments["errorMessage"] = error.description
                    channel.invokeMethod(YandexConsts.ON_BANNER_AD_LOAD_FAILED, arguments)
                }
            }

            override fun onAdClicked() {
                Handler(Looper.getMainLooper()).post {
                    val arguments = HashMap<String, Any>()
                    channel.invokeMethod(YandexConsts.ON_BANNER_AD_CLICKED, arguments)
                }
            }

            override fun onLeftApplication() {
                Log.d(TAG, "onLeftApplication")
            }

            override fun onReturnedToApplication() {
                Log.d(TAG, "onReturnedToApplication")
            }

            override fun onImpression(p0: ImpressionData?) {
                Handler(Looper.getMainLooper()).post {
                    val arguments = HashMap<String, Any>()
                    channel.invokeMethod(YandexConsts.ON_BANNER_AD_IMPRESSION_COUNTED, arguments)
                }
            }

        })
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
        when (call.method) {
            YandexConsts.REPORT_SIZE -> {
                val arguments = HashMap<String, Any>()
                Log.d(TAG, "BANNER SIZE: ${bannerView.adSize?.width ?: 0}, ${bannerView.adSize?.height ?: 0}")

                arguments["platformWidth"] = bannerView.adSize?.width ?: 0
                arguments["platformHeight"] = bannerView.adSize?.height ?: 0
                result.success(arguments)
            }
            YandexConsts.LOAD_BANNER -> {
                val adRequest = AdRequest.Builder().build()
                bannerView.loadAd(adRequest)
                val arguments = HashMap<String, Any>()
                result.success(arguments)
            }
            else -> {
                result.notImplemented()
            }
        }
    }
}
 