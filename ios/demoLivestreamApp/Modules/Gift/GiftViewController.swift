import UIKit
import TUICore

class GiftViewController: UIViewController {
    
    private enum GiftCategory: String, CaseIterable {
        case popular = "Popular"
        case animation = "Animation"
        case special = "Special"
    }
    
    private var selectedCategory: GiftCategory = .popular
    private var gifts: [[Gift]] = []
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.delegate = self
        cv.dataSource = self
        cv.register(GiftCell.self, forCellWithReuseIdentifier: "GiftCell")
        return cv
    }()
    
    private lazy var categorySegmentControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: GiftCategory.allCases.map { $0.rawValue })
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(categoryChanged), for: .valueChanged)
        return sc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadGifts()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(categorySegmentControl)
        view.addSubview(collectionView)
        
        categorySegmentControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(categorySegmentControl.snp.bottom).offset(20)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    private func loadGifts() {
        // Load gifts based on selected category
        // This would typically come from your backend
        gifts = [
            // Popular gifts
            [
                Gift(id: "1", name: "Heart", price: 10, imageUrl: "gift_heart"),
                Gift(id: "2", name: "Star", price: 20, imageUrl: "gift_star"),
                // Add more gifts...
            ],
            // Animation gifts
            [
                Gift(id: "3", name: "Fireworks", price: 50, imageUrl: "gift_fireworks"),
                Gift(id: "4", name: "Rainbow", price: 100, imageUrl: "gift_rainbow"),
                // Add more gifts...
            ],
            // Special gifts
            [
                Gift(id: "5", name: "Crown", price: 500, imageUrl: "gift_crown"),
                Gift(id: "6", name: "Castle", price: 1000, imageUrl: "gift_castle"),
                // Add more gifts...
            ]
        ]
        
        collectionView.reloadData()
    }
    
    @objc private func categoryChanged(_ sender: UISegmentedControl) {
        selectedCategory = GiftCategory.allCases[sender.selectedSegmentIndex]
        loadGifts()
    }
}

// MARK: - UICollectionView DataSource & Delegate
extension GiftViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, 
                       numberOfItemsInSection section: Int) -> Int {
        return gifts[selectedCategory.index].count
    }
    
    func collectionView(_ collectionView: UICollectionView, 
                       cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GiftCell", 
                                                     for: indexPath) as! GiftCell
        let gift = gifts[selectedCategory.index][indexPath.item]
        cell.configure(with: gift)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, 
                       didSelectItemAt indexPath: IndexPath) {
        let gift = gifts[selectedCategory.index][indexPath.item]
        showGiftPreview(gift)
    }
}

// MARK: - Gift Preview
extension GiftViewController {
    
    private func showGiftPreview(_ gift: Gift) {
        let previewVC = GiftPreviewViewController(gift: gift)
        previewVC.modalPresentationStyle = .overFullScreen
        previewVC.delegate = self
        present(previewVC, animated: true)
    }
}

// MARK: - GiftPreviewDelegate
extension GiftViewController: GiftPreviewDelegate {
    
    func didConfirmGift(_ gift: Gift) {
        // Send gift to current live stream
        TUILiveKit.sendGift(gift.id, to: currentUserId) { [weak self] success in
            if success {
                self?.showGiftAnimation(gift)
            } else {
                self?.showError("Failed to send gift")
            }
        }
    }
    
    private func showGiftAnimation(_ gift: Gift) {
        let animationVC = GiftAnimationViewController(gift: gift)
        animationVC.modalPresentationStyle = .overFullScreen
        present(animationVC, animated: false)
    }
} 