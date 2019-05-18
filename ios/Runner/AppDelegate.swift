import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    let path = Bundle.main.path(forResource: "GoogleMaps", ofType: "plist")
    let gmapsdict = NSDictionary(contentsOfFile: path!)!
    GMSServices.provideAPIKey(gmapsdict["key"] as! String)
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
