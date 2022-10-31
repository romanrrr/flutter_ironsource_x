import 'dart:async';

import 'package:flutter/services.dart';
import 'Ironsource_consts.dart';
import 'models.dart';
import 'package:flutter/material.dart';


enum IronsourceAdEvent {
  adOpened,
  adClosed,
  adAvailabilityChanged,
  adStarted,
  adEnded,
  adRewarded,
  adShowFailed,
  adShown,
  adClicked,
  adReady,
  interstitialAdLoadFailed
}

typedef IronsourceAdListener(IronsourceAdEvent event, dynamic arguments);

class IronSource {
  static const MethodChannel _channel =
  MethodChannel("com.metamorfosis_labs.flutter_ironsource_x");
  static IronsourceAdListener? _rewardedListener;
  static IronsourceAdListener? _interstititalListener;


  static set rewardedListener(IronsourceAdListener value) {
    _rewardedListener = value;
  }

  static set interstititalListener(IronsourceAdListener value) {
    _interstititalListener = value;
  }

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

  static Future<dynamic> shouldTrackNetworkState(bool state) async {
    await _channel.invokeMethod('shouldTrackNetworkState', {'state': state});
  }

  static Future<dynamic> validateIntegration() async {
    await _channel.invokeMethod('validateIntegration');
  }

  static Future<dynamic> setUserId(String userId) async {
    await _channel.invokeMethod('setUserId', {'userId': userId});
  }

  static Future<dynamic> getAdvertiserId() async {
    return await _channel.invokeMethod('getAdvertiserId');
  }

  static Future<dynamic> loadInterstitial() async {
    await _channel.invokeMethod('loadInterstitial');
  }

  static Future<dynamic> showInterstitial() async {
    await _channel.invokeMethod('showInterstitial');
  }

  static Future<dynamic> showRewardedVideo() async {
    await _channel.invokeMethod('showRewardedVideo');
  }

  static Future<dynamic> showOfferwall() async {
    await _channel.invokeMethod('showOfferwall');
  }

  static Future<dynamic> isInterstitialReady() async {
    return await _channel.invokeMethod('isInterstitialReady');
  }

  static Future<dynamic> activityResumed() async {
    await _channel.invokeMethod('activityResumed');
  }

  static Future<dynamic> activityPaused() async {
    await _channel.invokeMethod('activityPaused');
  }

  static Future<dynamic> isRewardedVideoAvailable() async {
    return await _channel.invokeMethod('isRewardedVideoAvailable');
  }

  static Future<dynamic> isOfferwallAvailable() async {
    return await _channel.invokeMethod('isOfferwallAvailable');
  }

  static final Map<String, IronsourceAdEvent> rewardedEventMap = {
    ON_REWARDED_VIDEO_AD_CLICKED: IronsourceAdEvent.adClicked,
    ON_REWARDED_VIDEO_AD_CLOSED: IronsourceAdEvent.adClosed,
    ON_REWARDED_VIDEO_AD_ENDED: IronsourceAdEvent.adEnded,
    ON_REWARDED_VIDEO_AD_OPENED: IronsourceAdEvent.adOpened,
    ON_REWARDED_VIDEO_AD_REWARDED: IronsourceAdEvent.adRewarded,
    ON_REWARDED_VIDEO_AD_SHOW_FAILED: IronsourceAdEvent.adShowFailed,
    ON_REWARDED_VIDEO_AVAILABILITY_CHANGED: IronsourceAdEvent.adAvailabilityChanged,
    ON_REWARDED_VIDEO_AD_STARTED: IronsourceAdEvent.adStarted,
  };

  static final Map<String, IronsourceAdEvent> interstitialEventMap = {
    ON_INTERSTITIAL_AD_CLICKED: IronsourceAdEvent.adClicked,
    ON_INTERSTITIAL_AD_CLOSED: IronsourceAdEvent.adClosed,
    ON_INTERSTITIAL_AD_OPENED: IronsourceAdEvent.adOpened,
    ON_INTERSTITIAL_AD_READY: IronsourceAdEvent.adReady,
    ON_INTERSTITIAL_AD_SHOW_SUCCEEDED: IronsourceAdEvent.adShown,
    ON_INTERSTITIAL_AD_LOAD_FAILED: IronsourceAdEvent.interstitialAdLoadFailed,
    ON_INTERSTITIAL_AD_SHOW_FAILED: IronsourceAdEvent.adShowFailed,
  };

  static Future<dynamic> _handle(MethodCall call) async {
    if(rewardedEventMap.containsKey(call.method)) {
      _rewardedListener?.call(
          rewardedEventMap[call.method]!, call.arguments);
    }else if(interstitialEventMap.containsKey(call.method)){
      _interstititalListener?.call(
          interstitialEventMap[call.method]!, call.arguments);
    }
  }
}
