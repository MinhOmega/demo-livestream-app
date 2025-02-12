import UIKit
import TUICore
import TUILiveKit

class LiveStreamViewController: UIViewController {
    
    private var roomId: String
    private let giftButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "gift_icon"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "close_icon"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    init(roomId: String) {
        self.roomId = roomId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLiveStream()
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        
        view.addSubview(giftButton)
        view.addSubview(closeButton)
        
        giftButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.width.height.equalTo(44)
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(44)
        }
        
        giftButton.addTarget(self, action: #selector(showGiftPanel), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closeLiveStream), for: .touchUpInside)
    }
    
    private func setupLiveStream() {
        // Initialize live stream with TUIKit
        TUILiveKit.createInstance().joinLive(roomId: roomId) { [weak self] success in
            if success {
                print("Joined live stream successfully")
            } else {
                self?.showError("Failed to join live stream")
            }
        }
    }
    
    @objc private func showGiftPanel() {
        let giftVC = GiftViewController()
        giftVC.delegate = self
        giftVC.modalPresentationStyle = .overFullScreen
        present(giftVC, animated: true)
    }
    
    @objc private func closeLiveStream() {
        TUILiveKit.createInstance().leaveLive { [weak self] in
            self?.dismiss(animated: true)
        }
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - GiftViewControllerDelegate
extension LiveStreamViewController: GiftViewControllerDelegate {
    func didSendGift(_ gift: Gift) {
        // Show gift animation
        let animationVC = GiftAnimationViewController(gift: gift)
        animationVC.modalPresentationStyle = .overFullScreen
        present(animationVC, animated: false)
        
        // Send gift through TUIKit
        TUILiveKit.createInstance().sendGift(gift.id, to: roomId) { [weak self] success in
            if !success {
                self?.showError("Failed to send gift")
            }
        }
    }
} 