import UIKit
import React
import React_RCTAppDelegate
import ReactAppDependencyProvider
import TUICore

@main
class AppDelegate: RCTAppDelegate {
  override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    self.moduleName = "demoLivestreamApp"
    self.dependencyProvider = RCTAppDependencyProvider()

    // You can add your custom initial props in the dictionary below.
    // They will be passed down to the ViewController used by React Native.
    self.initialProps = [:]

    // Initialize TUILogin
    TUILogin.login(20018723,                // Replace it with the SDKAppID obtained in Step 1
            userID: "denny",                 // Replace with your UserID
            userSig: "xxxxxxxxxxx") {        // Calculate a UserSig in the console and enter it here
      print("login success")
    } fail: { (code, message) in
      print("login failed, code: \(code), error: \(message ?? "nil")")
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func sourceURL(for bridge: RCTBridge) -> URL? {
    self.bundleURL()
  }

  override func bundleURL() -> URL? {
#if DEBUG
    RCTBundleURLProvider.sharedSettings().jsBundleURL(forBundleRoot: "index")
#else
    Bundle.main.url(forResource: "main", withExtension: "jsbundle")
#endif
  }
}
