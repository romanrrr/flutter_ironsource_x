import Flutter
import UIKit

public class SwiftFlutterIronsource_xPlugin: NSObject, FlutterPlugin {
    
    private static var interstitialDelegate: ISInterstitialDelegate?;
    private static var rewardedDelegate: ISRewardedVideoDelegate?;

    
    class InterstitialDelegate : NSObject, ISInterstitialDelegate{
        func interstitialDidLoad() {
            channel.invokeMethod("onInterstitialAdReady", arguments: nil)
        }
        
        func interstitialDidFailToLoadWithError(_ error: Error!) {
            channel.invokeMethod("onInterstitialAdLoadFailed", arguments: nil)
        }
        
        func interstitialDidOpen() {
            channel.invokeMethod("onInterstitialAdOpened", arguments: nil)
        }
        
        func interstitialDidClose() {
            channel.invokeMethod("onInterstitialAdClosed", arguments: nil)
        }
        
        func interstitialDidShow() {
            channel.invokeMethod("onInterstitialAdShowSucceeded", arguments: nil)
        }
        
        func interstitialDidFailToShowWithError(_ error: Error!) {
            channel.invokeMethod("onInterstitialAdShowFailed", arguments: nil)
        }
        
        func didClickInterstitial() {
            channel.invokeMethod("onInterstitialAdClicked", arguments: nil)
        }
        
        
        var channel: FlutterMethodChannel;
        
        init(channel: FlutterMethodChannel){
            self.channel = channel;
        }
        
    }
    
    
    class RewardedDelegate : NSObject, ISRewardedVideoDelegate {
        
        func rewardedVideoHasChangedAvailability(_ available: Bool) {
            channel.invokeMethod("onRewardedVideoAvailabilityChanged", arguments: available)
        }
        
        func didReceiveReward(forPlacement placementInfo: ISPlacementInfo!) {
            let data = [
                "placementId": "",
                "placementName": placementInfo.placementName,
                "rewardAmount": "\(placementInfo.rewardAmount ?? 0)",
                "rewardName": placementInfo.rewardName,
            ]
            channel.invokeMethod("onRewardedVideoAdRewarded", arguments: data)
        }
        
        func rewardedVideoDidFailToShowWithError(_ error: Error!) {
            channel.invokeMethod("onRewardedVideoAdShowFailed", arguments: nil)
        }
        
        func rewardedVideoDidOpen() {
            channel.invokeMethod("onRewardedVideoAdOpened", arguments: nil)
        }
        
        func rewardedVideoDidClose() {
            channel.invokeMethod("onRewardedVideoAdClosed", arguments: nil)
        }
        
        func rewardedVideoDidStart() {
            channel.invokeMethod("onRewardedVideoAdStarted", arguments: nil)
        }
        
        func rewardedVideoDidEnd() {
            channel.invokeMethod("onRewardedVideoAdEnded", arguments: nil)
        }
        
        func didClickRewardedVideo(_ placementInfo: ISPlacementInfo!) {
            let data = [
                "placementId": "",
                "placementName": placementInfo.placementName,
                "rewardAmount": "\(placementInfo.rewardAmount ?? 0)",
                "rewardName": placementInfo.rewardName,
            ]
            channel.invokeMethod("onRewardedVideoAdClicked", arguments: data)
        }
        
        
        var channel: FlutterMethodChannel;
        
        init(channel: FlutterMethodChannel){
            self.channel = channel;
        }
    }
    
    var channel: FlutterMethodChannel;
    init(channel: FlutterMethodChannel) {
        self.channel = channel

    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "com.metamorfosis_labs.flutter_ironsource_x", binaryMessenger: registrar.messenger())
        
        
        let instance = SwiftFlutterIronsource_xPlugin(channel: channel)
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        rewardedDelegate = RewardedDelegate(channel: channel)
        interstitialDelegate = InterstitialDelegate(channel: channel)
        
        IronSource.setRewardedVideoDelegate(rewardedDelegate!)
        IronSource.setInterstitialDelegate(interstitialDelegate!)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        if (call.method == "getPlatformVersion") {
            result("iOS " + UIDevice.current.systemVersion)
        }
        else if (call.method == "initialize") {
            let myArgs = call.arguments as? [String: Any]
            let appKey = myArgs?["appKey"] as? String ?? ""
            let gdprConsent = myArgs?["gdprConsent"] as? Bool ?? false
            let ccpaConsent = myArgs?["ccpaConsent"] as? Bool ?? false
            if(ccpaConsent){
                IronSource.setMetaDataWithKey("do_not_sell", value: "NO")
            }else{
                IronSource.setMetaDataWithKey("do_not_sell", value: "YES")
            }
            IronSource.setConsent(gdprConsent)
            IronSource.setMetaDataWithKey("is_child_directed", value: "NO")
            IronSource.initWithAppKey(appKey, adUnits: [IS_REWARDED_VIDEO, IS_INTERSTITIAL])
        }else if (call.method == "shouldTrackNetworkState") {
            let myArgs = call.arguments as? [String: Any]
            let state = myArgs?["state"] as? Bool ?? false
            IronSource.shouldTrackReachability(state)
        }else if (call.method == "validateIntegration") {
            ISIntegrationHelper.validateIntegration()
        }
        else if (call.method == "loadInterstitial") {
            IronSource.loadInterstitial()
        }else if (call.method == "showInterstitial") {
            if let viewController = UIApplication.shared.keyWindow!.rootViewController {
                    IronSource.showInterstitial(with: viewController)
            }
        }else if (call.method == "isInterstitialReady") {
            result(IronSource.hasInterstitial())
        }else if (call.method == "isRewardedVideoAvailable") {
            result(IronSource.hasRewardedVideo())
        }else if (call.method == "showRewardedVideo") {
            if let viewController = UIApplication.shared.keyWindow!.rootViewController {
                IronSource.showRewardedVideo(with: viewController)
            }
        }
        result(true)
    }
}
