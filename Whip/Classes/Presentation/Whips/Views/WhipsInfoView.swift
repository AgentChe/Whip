//
//  WhipsInfoView.swift
//  Whip
//
//  Created by Андрей Чернышев on 03.04.2024.
//

import UIKit

final class WhipsInfoView: UIView {
    lazy var nameLabel = makeLabel()
    lazy var closeButton = makeCloseButton()
    lazy var imageView = makeImageView()
    lazy var descriptionLabel = makeLabel()
    
    private lazy var nameAttrs = TextAttributes()
        .textColor(Appearance.darkGrey)
        .font(Fonts.Inter.bold(size: 18.scale))
        .lineHeight(26.scale)
        .textAlignment(.center)
        .letterSpacing(3.scale)
    private lazy var descriptionAttrs = TextAttributes()
        .textColor(Appearance.darkGrey)
        .font(Fonts.Inter.regular(size: 18.scale))
        .lineHeight(24.scale)
        .textAlignment(.center)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let width = rect.width
        let height = rect.height

        let radius = 24.scale

        let arrowWidth = 24.scale
        let arrowHeight = 18.scale

        let startingPoint = CGPoint(x: radius, y: arrowHeight)
        let upperRightCenter = CGPoint(x: width - radius, y: radius + arrowHeight)
        let bottomRightCenter = CGPoint(x: width - radius, y: height - radius)
        let bottomLeftCenter = CGPoint(x: radius, y: height - radius)
        let upperLeftCenter = CGPoint(x: radius, y: radius + arrowHeight)

        let path: UIBezierPath = UIBezierPath()

        path.move(to: startingPoint)
        
        path.addLine(to: CGPoint(x: width / 2 - arrowWidth / 2, y: arrowHeight))
        path.addLine(to: CGPoint(x: width / 2, y: 0))
        path.addLine(to: CGPoint(x: width / 2 + arrowWidth / 2, y: arrowHeight))
        
        path.addArc(withCenter: upperRightCenter, radius: radius, startAngle: 270.degreesToRadians, endAngle: 0, clockwise: true)

        path.addArc(withCenter: bottomRightCenter, radius: radius, startAngle: 0, endAngle: 90.degreesToRadians, clockwise: true)

        path.addArc(withCenter: bottomLeftCenter, radius: radius, startAngle: 90.degreesToRadians, endAngle: 180.degreesToRadians, clockwise: true)

        path.addArc(withCenter: upperLeftCenter, radius: radius, startAngle: 180.degreesToRadians, endAngle: 270.degreesToRadians, clockwise: true)

        path.close()

        Appearance.white.setFill()
        Appearance.beige.setStroke()

        path.fill()
        path.stroke()
    }
}

// MARK: Public
extension WhipsInfoView {
    func setup(whip: Whip) {
        nameLabel.attributedText = whip.name.attributed(with: nameAttrs)
        descriptionLabel.attributedText = whip.description.attributed(with: descriptionAttrs)
        imageView.image = UIImage(named: whip.largeImageName)
    }
}

// MARK: Private
private extension WhipsInfoView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
}

// MARK: Make constraints
private extension WhipsInfoView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 56.scale)
        ])
        
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 44.scale),
            closeButton.heightAnchor.constraint(equalToConstant: 44.scale),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.scale),
            closeButton.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 160.scale),
            imageView.heightAnchor.constraint(equalToConstant: 160.scale),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 26.scale)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 39.scale),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -39.scale),
            descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 26.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension WhipsInfoView {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCloseButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Whips.Description.Close"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

// MARK: Additional
private extension Int {
    var degreesToRadians: CGFloat {
        CGFloat.pi * CGFloat(self) / 180.0
    }
}
