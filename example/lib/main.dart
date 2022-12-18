import 'package:flutter/material.dart';
import 'package:flutter_yandex_mobile_ads/banner.dart';
import 'package:flutter_yandex_mobile_ads/yandex.dart';
import 'package:flutter_yandex_mobile_ads_example/flex_banner_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: YandexMobileAdsDemo(),
    );
  }
}

class YandexMobileAdsDemo extends StatefulWidget{
  @override
  State<YandexMobileAdsDemo> createState() => _YandexMobileAdsDemoState();
}

class _YandexMobileAdsDemoState extends State<YandexMobileAdsDemo> {
  String status = "Try to load Ads";

  bool interstitialLoaded = false;
  bool rewardedLoaded = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    await Yandex.initialize();
    setState(() {});
  }

  void loadInterstitial() {
    setState(() {
      status = "LoadingInterstitial";
    });
    listener(YandexAdEvent event, dynamic args) {
      debugPrint("INTER ADS: Yandex event: $event");
      if (event == YandexAdEvent.adReady) {
        setState(() {
          interstitialLoaded = true;
          status = "Interstitial Loaded";
        });
      } else if (event == YandexAdEvent.adLoadFailed) {
        setState(() {
          status = "Interstitial Failed To Load: ${args['errorMessage']}";
        });
      }
    }

    Yandex.interstititalListener = listener;
    Yandex.loadInterstitial("R-M-DEMO-interstitial");
  }

  void showInterstitial() {
    if (interstitialLoaded) {
      setState(() {
        status = "Showing Interstitial";
        interstitialLoaded = false;
        Yandex.showInterstitial();
      });
    }
  }

  void loadRewardedVideo() {
    setState(() {
      status = "Loading Rewarded Video";
    });
    var listener = (YandexAdEvent event, dynamic args) {
      if (event == YandexAdEvent.adReady) {
        setState(() {
          rewardedLoaded = true;
          status = "Rewarded Video Loaded";
        });
      } else if (event == YandexAdEvent.adLoadFailed) {
        setState(() {
          status = "Failed To Load Rewarded Video: ${args['errorMessage']}";
        });
      } else if (event == YandexAdEvent.adRewarded) {
        setState(() {
          status = "Rewarded";
        });
      }
    };
    Yandex.rewardedListener = listener;
    Yandex.loadRewarded("R-M-DEMO-rewarded-client-side-rtb");
  }

  void showRewardedVideo() {
    if (rewardedLoaded) {
      setState(() {
        status = "Showing Rewarded";
        rewardedLoaded = false;
        Yandex.showRewardedVideo();
      });
    }
  }

  void openFlexBannerPage(){
    debugPrint("Open Banner");
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (BuildContext context) {
        return FlexBannerPage(); // ... to here.
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Flutter Yandex Mobile Ads'),
      ),
      body: Container(
        //padding: EdgeInsets.symmetric(vertical: 50.0),
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextButton(
                onPressed: loadInterstitial,
                child: Text("Load Interstitial")),
            TextButton(
                onPressed: showInterstitial,
                child: Text("Show Interstitial")),

            TextButton(
                onPressed: loadRewardedVideo,
                child: Text("Load Rewarded Video")),
            TextButton(
                onPressed: showRewardedVideo,
                child: Text("Show Rewarded Video")),
            TextButton(
                onPressed: openFlexBannerPage,
                child: Text("Open FLex Banner Page")),

            Expanded(
                child: Container(
                    alignment: Alignment.center, child: Text(status))),
            Container(height: 2, color: Colors.green,),
            YandexBanner(
              adUnitId: "R-M-DEMO-300x250",
              size: YandexBannerSize.stickySize(width.toInt()),
              listener: (event, arguments) {
                switch(event){
                  case YandexAdEvent.adReady:
                    setState(() {
                      status = "Banner Loaded";
                    });
                    break;
                  case YandexAdEvent.adLoadFailed:
                    setState(() {
                      status = "Banner Load Failed: ${arguments['errorMessage']}";
                    });
                    break;
                  case YandexAdEvent.adClicked:
                    setState(() {
                      status = "Banner Clicked";
                    });
                    break;
                }
              },
            ),
            Container(height: 2, color: Colors.green,)
          ],
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String label;
  final Function onPressed;

  const CustomButton({Key key, this.label, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: MaterialButton(
        minWidth: 250.0,
        height: 50.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
            side: BorderSide(width: 2.0, color: Colors.blue)),
        child: Text(
          label.toUpperCase(),
          style: TextStyle(),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
