class GiftAnimationViewController: UIViewController {
    
    private let gift: Gift
    private let giftImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
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
        animateGift()
    }
    
    private func setupUI() {
        view.backgroundColor = .clear
        view.addSubview(giftImageView)
        
        giftImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(200)
        }
        
        giftImageView.image = UIImage(named: gift.imageUrl)
        giftImageView.alpha = 0
    }
    
    private func animateGift() {
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.giftImageView.alpha = 1
            self?.giftImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: 1.0, options: [], animations: { [weak self] in
                self?.giftImageView.alpha = 0
                self?.giftImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }) { [weak self] _ in
                self?.dismiss(animated: false)
            }
        }
    }
} 