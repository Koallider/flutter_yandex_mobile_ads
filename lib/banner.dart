import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_yandex_mobile_ads/yandex.dart';
import 'package:flutter_yandex_mobile_ads/yandex_consts.dart';

/// Banner size.
class YandexBannerSize {
  final int width;
  final int? height;

  YandexBannerSize._({required this.width, this.height});

  factory YandexBannerSize.stickySize(int width) {
    return YandexBannerSize._(width: width);
  }

  factory YandexBannerSize.flexibleSize(int width, int height) {
    return YandexBannerSize._(width: width, height: height);
  }
}

/// Widget do display Yandex Mobile Ads banner;
///
/// More info: https://yandex.com/dev/mobile-ads/doc/android/quick-start/banner.html
class YandexBanner extends StatefulWidget {
  final YandexBannerSize size;

  /// Ad Unit id in R-M-XXXXXX-Y format from the Partner Interface
  final String adUnitId;

  /// Ad Events Listener.
  ///
  /// Possible Banner Events:
  /// [YandexAdEvent.adReady]
  /// [YandexAdEvent.adLoadFailed]
  /// [YandexAdEvent.adClicked]
  /// [YandexAdEvent.adImpressionCounted]
  final YandexAdListener? listener;

  YandexBanner(
      {required this.size, required this.adUnitId, this.listener, super.key});

  @override
  State<YandexBanner> createState() => _YandexBannerState();
}

class _YandexBannerState extends State<YandexBanner> {
  late YandexBannerSize _platformBannerSize;
  late MethodChannel channel;

  @override
  void initState() {
    super.initState();
    _platformBannerSize = YandexBannerSize.flexibleSize(widget.size.width, 2);
  }

  @override
  void dispose() {
    channel.setMethodCallHandler(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget platformView;
    var creationParams = <String, dynamic>{
      "adUnitId": widget.adUnitId,
      "height": widget.size.height,
      "width": widget.size.width,
    };
    if (Platform.isAndroid) {
      platformView = AndroidView(
        viewType: BANNER_CHANNEL,
        onPlatformViewCreated: _onBannerCreated,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else {
      platformView = UiKitView(
        viewType: BANNER_CHANNEL,
        layoutDirection: TextDirection.ltr,
        creationParams: creationParams,
        onPlatformViewCreated: _onBannerCreated,
        creationParamsCodec: const StandardMessageCodec(),
      );
    }
    return Container(
        width: _platformBannerSize.width.toDouble(),
        height: _platformBannerSize.height?.toDouble() ?? 0,
        color: Colors.transparent,
        child: platformView);
  }

  void _onBannerCreated(int id) {
    channel = MethodChannel('$BANNER_CHANNEL$id');
    channel.setMethodCallHandler(_handle);
    channel.invokeMethod(LOAD_BANNER);
  }

  final Map<String, YandexAdEvent> _bannerEventMap = {
    ON_BANNER_AD_LOADED: YandexAdEvent.adReady,
    ON_BANNER_AD_LOAD_FAILED: YandexAdEvent.adLoadFailed,
    ON_BANNER_AD_CLICKED: YandexAdEvent.adClicked,
    ON_BANNER_AD_IMPRESSION_COUNTED: YandexAdEvent.adImpressionCounted,
  };

  Future<dynamic> _handle(MethodCall call) async {
    if (call.method == ON_BANNER_AD_LOADED) {
      updateSize();
    }
    if (call.method == ON_BANNER_AD_LOAD_FAILED) {
      setState(() {
        int width = 0;
        int height = 0;
        _platformBannerSize = YandexBannerSize.flexibleSize(width, height);
      });
    }
    if (_bannerEventMap.containsKey(call.method)) {
      widget.listener?.call(_bannerEventMap[call.method]!, call.arguments);
    }
  }

  void updateSize() {
    channel.invokeMethod(REPORT_SIZE).then((value) {
      setState(() {
        int width = max(2, value["platformWidth"]);
        int height = max(2, value["platformHeight"]);
        _platformBannerSize = YandexBannerSize.flexibleSize(width, height);
      });
    });
  }
}
