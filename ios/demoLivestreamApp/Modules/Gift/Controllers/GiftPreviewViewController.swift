protocol GiftPreviewDelegate: AnyObject {
    func didConfirmGift(_ gift: Gift)
}

class GiftPreviewViewController: UIViewController {
    
    private let gift: Gift
    weak var delegate: GiftPreviewDelegate?
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let giftImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send Gift", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
        return button
    }()
    
    init(gift: Gift) {
        self.gift = gift
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        view.addSubview(containerView)
        containerView.addSubview(giftImageView)
        containerView.addSubview(confirmButton)
        
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(280)
            make.height.equalTo(320)
        }
        
        giftImageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(20)
            make.height.equalTo(200)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        giftImageView.image = UIImage(named: gift.imageUrl)
    }
    
    @objc private func confirmTapped() {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.delegate?.didConfirmGift(self.gift)
        }
    }
} 