import Foundation
import React

@objc(LiveStreamBridge)
public class LiveStreamBridge: NSObject, RCTBridgeModule {
    private weak var bridge: RCTBridge?
    
    public init(bridge: RCTBridge) {
        self.bridge = bridge
        super.init()
    }
    
    @objc
    public static func moduleName() -> String! {
        return "LiveStreamBridge"
    }
    
    @objc
    public static func requiresMainQueueSetup() -> Bool {
        return true
    }
    
    @objc
    func joinLiveStream(_ roomId: String,
                       resolver: @escaping RCTPromiseResolveBlock,
                       rejecter: @escaping RCTPromiseRejectBlock) {
        DispatchQueue.main.async {
            if let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
                let liveVC = LiveStreamViewController(roomId: roomId)
                liveVC.modalPresentationStyle = .fullScreen
                
                keyWindow.rootViewController?.present(liveVC, animated: true) {
                    resolver(["success": true])
                }
            } else {
                rejecter("ERROR", "Could not show live stream", nil)
            }
        }
    }
} 