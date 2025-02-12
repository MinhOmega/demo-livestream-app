import UIKit
import SnapKit

class LoginRootView: UIView {
    
    weak var rootVC: LoginViewController?
    
    // MARK: - UI Components
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "login_logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var phoneNumTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Phone Number"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.backgroundColor = .white
        textField.layer.borderColor = UIColor(hex: "EEEEEE")?.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 8
        return textField
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(hex: "006EFF")
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        backgroundColor = .white
        
        addSubview(logoImageView)
        addSubview(phoneNumTextField)
        addSubview(loginButton)
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(60)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        phoneNumTextField.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(40)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(48)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(phoneNumTextField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(48)
        }
    }
    
    // MARK: - Actions
    
    @objc private func handleLogin() {
        guard let phone = phoneNumTextField.text, !phone.isEmpty else {
            // Show error
            rootVC?.view.makeToast("Please enter phone number")
            return
        }
        rootVC?.login(userId: phone)
    }
} 