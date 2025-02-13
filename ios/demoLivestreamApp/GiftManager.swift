import Foundation
import React

@objc(GiftManager)
class GiftManager: RCTEventEmitter {
  
  override static func moduleName() -> String! {
    return "GiftManager"
  }
  
  override static func requiresMainQueueSetup() -> Bool {
    return true
  }
  
  override func supportedEvents() -> [String]! {
    return []
  }
  
  @objc(showGiftAnimation:callback:)
  func showGiftAnimation(_ giftType: String, callback: @escaping RCTResponseSenderBlock) {
    DispatchQueue.main.async {
      // Show native gift animation
      let giftView = GiftAnimationView(frame: UIScreen.main.bounds)
      giftView.showGift(type: giftType)
      
      if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
         let window = windowScene.windows.first {
        window.addSubview(giftView)
      }
      
      callback([NSNull(), true])
    }
  }
} 
