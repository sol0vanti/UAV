import UIKit

class CustomButton: UIButton {
    private var iconImageView: UIImageView!
    private var rightIconImageView: UIImageView!

    func setIconImage(_ image: UIImage?) {
        iconImageView.image = image
        rightIconImageView.image = UIImage(systemName: "chevron.right")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }

    private func setupButton() {
        iconImageView = UIImageView(frame: CGRect(x: 25, y: 0, width: 30, height: bounds.height))
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .lightGray
        addSubview(iconImageView)

        let rightIconX = bounds.width - 25 - 30
        rightIconImageView = UIImageView(frame: CGRect(x: rightIconX, y: 0, width: 15, height: bounds.height))
        rightIconImageView.contentMode = .scaleAspectFit
        rightIconImageView.tintColor = .lightGray
        addSubview(rightIconImageView)
    }
}
