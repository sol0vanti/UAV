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
        // Create and configure the left icon image view
        iconImageView = UIImageView(frame: CGRect(x: 25, y: 0, width: 30, height: bounds.height))
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .systemGray3
        addSubview(iconImageView)

        // Calculate the x position for rightIconImageView based on the button's width and margin
        let rightIconX = bounds.width - 25 - 30
        rightIconImageView = UIImageView(frame: CGRect(x: rightIconX, y: 0, width: 15, height: bounds.height))
        rightIconImageView.contentMode = .scaleAspectFit
        rightIconImageView.tintColor = .systemGray3
        addSubview(rightIconImageView)
    }
}
