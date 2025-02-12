import UIKit
import TUICore
import TUILiveKit

class LoginViewController: UIViewController {
    
    private let loading = UIActivityIndicatorView(style: .large)
    private var loginRootView: LoginRootView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupAutoLogin()
    }
    
    private func setupUI() {
        navigationController?.navigationBar.barTintColor = .white
        TUICSToastManager.setDefaultPosition(TUICSToastPositionBottom)
        
        view.addSubview(loading)
        loading.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.center.equalToSuperview()
        }
    }
    
    private func setupAutoLogin() {
        if ProfileManager.shared.autoLogin(success: { [weak self] in
            self?.loginIM { success in
                self?.loading.stopAnimating()
                if success {
                    self?.loginSucc()
                }
            }
        }, failed: { [weak self] error in
            self?.loading.stopAnimating()
            self?.view.makeToast(error)
        }) {
            loading.startAnimating()
            loginRootView.phoneNumTextField.text = ProfileManager.shared.curUserModel?.phone ?? ""
        }
    }
    
    func login(userId: String) {
        loading.startAnimating()
        
        TUILogin.login(Int32(SDKAPPID), 
                      userID: userId,
                      userSig: GenerateTestUserSig.genTestUserSig(identifier: userId)) { [weak self] in
            guard let self = self else { return }
            self.loading.stopAnimating()
            
            SettingsConfig.share.userId = userId
            UserDefaults.standard.set(userId, forKey: "UserIdKey")
            UserDefaults.standard.synchronize()
            
            self.getUserInfo(userId)
        } fail: { [weak self] code, errorDes in
            guard let self = self else { return }
            self.loading.stopAnimating()
            self.view.makeToast("Login failed: \(errorDes ?? "")")
        }
    }
    
    private func getUserInfo(_ userId: String) {
        V2TIMManager.sharedInstance()?.getUsersInfo([userId], succ: { [weak self] infos in
            guard let self = self,
                  let info = infos?.first else { return }
            
            SettingsConfig.share.avatar = info.faceURL ?? "default_avatar_url"
            SettingsConfig.share.name = info.nickName ?? ""
            
            self.loginSucc()
        }, fail: { code, err in
            debugPrint("Get user info failed: \(err ?? "")")
        })
    }
    
    private func loginIM(complete: @escaping (Bool) -> Void) {
        guard let userID = ProfileManager.shared.curUserID() else { return }
        let userSig = ProfileManager.shared.curUserSig()
        
        if TUILogin.getUserID() != userID {
            ProfileManager.shared.IMLogin(userSig: userSig) {
                debugPrint("IM login success")
                complete(true)
            } failed: { [weak self] error in
                self?.view.makeToast("Login IM failed")
                complete(false)
            }
        }
    }
    
    private func loginSucc() {
        if SettingsConfig.share.name.isEmpty {
            showRegisterVC()
        } else {
            self.view.makeToast("Login successful")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                TUILiveKit.createInstance().prepareLiveStream()
            }
        }
    }
    
    private func showRegisterVC() {
        let vc = RegisterViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func loadView() {
        super.loadView()
        loginRootView = LoginRootView()
        loginRootView.rootVC = self
        view = loginRootView
    }
} 