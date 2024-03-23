import UIKit

class ProfButton: UIButton {
    private var profImageView: UIImageView!
    
    func setProfImage(_ image: UIImage?) {
        profImageView.image = image
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpButton()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpButton()
    }
    
    private func setUpButton() {
        profImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height))
        profImageView.contentMode = .scaleAspectFit
        profImageView.backgroundColor = .systemRed
        addSubview(profImageView)
    }
}
