import 'package:flutter/material.dart';
import 'package:flutter_yandex_mobile_ads/banner.dart';

class FlexBannerPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      body: SafeArea(
        child: Column(
          children: [
            Text("Flex Banner Page", textAlign: TextAlign.center,),
            Expanded(child: Center(
              child: YandexBanner(
                adUnitId: "demo-banner-yandex",
                size: YandexBannerSize.flexibleSize(320, 320),
              ),
            ))
          ],
        ),
      ),
    );
  }
}