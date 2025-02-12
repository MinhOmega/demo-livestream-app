import UIKit
import React
import React_RCTAppDelegate
import ReactAppDependencyProvider

// Import custom modules
import RTCRoomEngine

@main
class AppDelegate: RCTAppDelegate {
  override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    self.moduleName = "demoLivestreamApp"
    self.dependencyProvider = RCTAppDependencyProvider()

    // You can add your custom initial props in the dictionary below.
    // They will be passed down to the ViewController used by React Native.
    self.initialProps = [:]

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func sourceURL(for bridge: RCTBridge) -> URL? {
    self.bundleURL()
  }

  override func bundleURL() -> URL? {
#if DEBUG
    return RCTBundleURLProvider.sharedSettings().jsBundleURL(forBundleRoot: "index")
#else
    return Bundle.main.url(forResource: "main", withExtension: "jsbundle")
#endif
  }

  func showMainViewController() {
    DispatchQueue.main.async {
      if let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
        let mainVC = UIViewController() // Temporary placeholder
        let rootVC = UINavigationController(rootViewController: mainVC)
        keyWindow.rootViewController = rootVC
        keyWindow.makeKeyAndVisible()
      }
    }
  }
  
  func showLoginViewController() {
    DispatchQueue.main.async {
      if let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
        let loginVC = UIViewController() // Temporary placeholder
        let nav = UINavigationController(rootViewController: loginVC)
        keyWindow.rootViewController = nav
        keyWindow.makeKeyAndVisible()
      }
    }
  }
}
