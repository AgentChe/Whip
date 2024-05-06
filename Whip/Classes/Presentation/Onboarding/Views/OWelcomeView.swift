//
//  OWelcomeView.swift
//  RingSizer
//
//  Created by Андрей Чернышев on 23.03.2024.
//

import UIKit

final class OWelcomeView: OSlideView {
    lazy var imageView = makeImageView()
    lazy var textLabel = makeTextLabel()
    lazy var continueButton = makeContinueButton()
    
    private let key: String
    
    override init(step: OnboardingView.Step) {
        switch step {
        case .welcome1:
            key = "Onboarding.Welcome1"
        case .welcome2:
            key = "Onboarding.Welcome2"
        case .welcome3:
            key = "Onboarding.Welcome3"
        }
        
        super.init(step: step)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension OWelcomeView {
    func initialize() {
        backgroundColor = Appearance.beige
    }
}

// MARK: Make constraints
private extension OWelcomeView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 298.scale),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 189.scale : 140.scale)
        ])
        
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            textLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 35.scale)
        ])
        
        NSLayoutConstraint.activate([
            continueButton.widthAnchor.constraint(equalToConstant: 357.scale),
            continueButton.heightAnchor.constraint(equalToConstant: 44.scale),
            continueButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -85.scale : -50.scale),
            continueButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension OWelcomeView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.image = UIImage(named: key)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTextLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.darkGrey)
            .font(Fonts.Inter.bold(size: 18.scale))
            .lineHeight(26.scale)
            .letterSpacing(3.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = key.localized.uppercased().attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContinueButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 253, green: 253, blue: 253))
            .font(Fonts.Inter.regular(size: 12.scale))
            .letterSpacing(1.scale)
        
        let view = UIButton()
        view.setAttributedTitle("Continue".localized.uppercased().attributed(with: attrs), for: .normal)
        view.backgroundColor = Appearance.darkGrey
        view.layer.cornerRadius = 22.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(onNext), for: .touchUpInside)
        addSubview(view)
        return view
    }
}
