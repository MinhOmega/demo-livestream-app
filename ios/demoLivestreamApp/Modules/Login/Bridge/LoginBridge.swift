import Foundation
import React
import UIKit
import TUICore
import TUILiveKit

@objc(LoginBridge)
public class LoginBridge: NSObject, RCTBridgeModule {
    private weak var bridge: RCTBridge?
    
    public init(bridge: RCTBridge) {
        self.bridge = bridge
        super.init()
    }
    
    @objc
    public static func moduleName() -> String! {
        return "LoginBridge"
    }
    
    @objc
    public static func requiresMainQueueSetup() -> Bool {
        return true
    }
    
    @objc
    func login(_ userId: String, 
               resolver: @escaping RCTPromiseResolveBlock,
               rejecter: @escaping RCTPromiseRejectBlock) {
        
        TUILogin.login(Int32(SDKAPPID), 
                      userID: userId,
                      userSig: GenerateTestUserSig.genTestUserSig(identifier: userId)) { [weak self] in
            
            SettingsConfig.share.userId = userId
            UserDefaults.standard.set(userId, forKey: "UserIdKey")
            UserDefaults.standard.synchronize()
            
            // Get user info after successful login
            self?.getUserInfo(userId, resolver: resolver)
            
        } fail: { code, errorDes in
            rejecter("LOGIN_ERROR", 
                    "Login failed: \(errorDes ?? "Unknown error")", 
                    NSError(domain: "", code: Int(code), userInfo: nil))
        }
    }
    
    private func getUserInfo(_ userId: String, resolver: @escaping RCTPromiseResolveBlock) {
        V2TIMManager.sharedInstance()?.getUsersInfo([userId], succ: { [weak self] infos in
            guard let info = infos?.first else {
                resolver(["success": true])
                return
            }
            
            SettingsConfig.share.avatar = info.faceURL ?? "default_avatar_url"
            SettingsConfig.share.name = info.nickName ?? ""
            
            resolver(["success": true])
            
        }, fail: { code, err in
            // Still resolve as success even if getting user info fails
            resolver(["success": true])
        })
    }
    
    @objc
    func showLoginViewController(_ resolve: @escaping RCTPromiseResolveBlock,
                               rejecter: @escaping RCTPromiseRejectBlock) {
        DispatchQueue.main.async {
            if let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
                let loginVC = LoginViewController()
                let nav = UINavigationController(rootViewController: loginVC)
                nav.modalPresentationStyle = .fullScreen
                
                if let rootVC = keyWindow.rootViewController {
                    rootVC.present(nav, animated: true) {
                        resolve(true)
                    }
                } else {
                    keyWindow.rootViewController = nav
                    keyWindow.makeKeyAndVisible()
                    resolve(true)
                }
            } else {
                rejecter("ERROR", "Could not show login view controller", nil)
            }
        }
    }
    
    @objc
    func showMainViewController(_ resolve: @escaping RCTPromiseResolveBlock,
                              rejecter: @escaping RCTPromiseRejectBlock) {
        DispatchQueue.main.async {
            if let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
                let mainVC = MainViewController()
                let nav = UINavigationController(rootViewController: mainVC)
                nav.modalPresentationStyle = .fullScreen
                
                keyWindow.rootViewController = nav
                keyWindow.makeKeyAndVisible()
                resolve(true)
            } else {
                rejecter("ERROR", "Could not show main view controller", nil)
            }
        }
    }
} 