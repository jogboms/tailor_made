import UIKit
import Flutter
import AVFoundation

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  var _result: FlutterResult!
  var CHANNEL_NAME = "io.github.jogboms.tailormade/alert"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    application.isStatusBarHidden = false
    application.statusBarStyle = .lightContent
    GeneratedPluginRegistrant.register(with: self)
    let controller = self.window.rootViewController
    let channel = FlutterMethodChannel(name: CHANNEL_NAME, binaryMessenger: controller as! FlutterBinaryMessenger);
    
    channel.setMethodCallHandler(handle)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch (call.method) {
    case "beep":
      AudioServicesPlayAlertSound(SystemSoundID(1315))
      result(NSNull())
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
