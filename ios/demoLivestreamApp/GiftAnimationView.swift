import UIKit

class GiftAnimationView: UIView {
  private let imageView = UIImageView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupView()
  }
  
  private func setupView() {
    backgroundColor = .clear
    
    imageView.contentMode = .scaleAspectFit
    imageView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(imageView)
    
    NSLayoutConstraint.activate([
      imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
      imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
      imageView.widthAnchor.constraint(equalToConstant: 150),
      imageView.heightAnchor.constraint(equalToConstant: 150)
    ])
  }
  
  func showGift(type: String) {
    let imageName: String
    switch type.lowercased() {
      case "heart": imageName = "gift_heart"
      case "star": imageName = "gift_star"
      case "diamond": imageName = "gift_diamond"
      default: imageName = "gift_heart"
    }
    
    imageView.image = UIImage(named: imageName)
    
    UIView.animate(withDuration: 0.5, animations: {
      self.imageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
    }) { _ in
      UIView.animate(withDuration: 0.3, delay: 1.5, options: [], animations: {
        self.imageView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        self.alpha = 0
      }) { _ in
        self.removeFromSuperview()
      }
    }
  }
} 