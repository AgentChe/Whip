//
//  PaygateView.swift
//  CodeChallenge
//
//  Created by Андрей Чернышев on 20.02.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class PaygateView: UIView {
    lazy var closeButton = makeCloseButton()
    lazy var imageView = makeImageView()
    lazy var titleLabel = makeTitleLabel()
    lazy var productView = makeProductView()
    lazy var buyButton = makeBuyButton()
    lazy var cancelAnytimeLabel = makeCancelAnytimeLabel()
    lazy var linksLabel = makeLinksLabel()
    lazy var restoreButton = makeRestoreButton()
    lazy var preloader = makePreloader()
    
    private lazy var didTapTermsOfUseTrigger = PublishRelay<Void>()
    private lazy var didTapPrivacyPolicyTrigger = PublishRelay<Void>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension PaygateView {
    var didTapTermsOfUse: Signal<Void> {
        didTapTermsOfUseTrigger.asSignal()
    }
    
    var didTapPrivacyPolicy: Signal<Void> {
        didTapPrivacyPolicyTrigger.asSignal()
    }
}

// MARK: Private
private extension PaygateView {
    func initialize() {
        backgroundColor = Appearance.beige
    }
    
    @objc
    func termsAndPolicyTapped(sender: UITapGestureRecognizer) {
        guard let label = sender.view as? UILabel, let text = label.text as NSString? else {
            return
        }
        
        let termsRange = text.range(of: "Paygate.TermsOfUse".localized)
        let policyRange = text.range(of: "Paygate.PrivacyPolicy".localized)

        if sender.didTapAttributedTextInLabel(label: label, inRange: termsRange) {
            didTapTermsOfUseTrigger.accept(Void())
        } else if sender.didTapAttributedTextInLabel(label: label, inRange: policyRange) {
            didTapPrivacyPolicyTrigger.accept(Void())
        }
    }
}

// MARK: Make constraints
private extension PaygateView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 24.scale),
            closeButton.heightAnchor.constraint(equalToConstant: 24.scale),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            closeButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 190.scale : 172.scale),
            imageView.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 204.scale : 185.scale),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: ScreenSize.isIphoneXFamily ? 81.scale : 60.scale)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 60.scale : 40.scale)
        ])
        
        NSLayoutConstraint.activate([
            productView.widthAnchor.constraint(equalToConstant: 314.scale),
            productView.heightAnchor.constraint(equalToConstant: 76.scale),
            productView.centerXAnchor.constraint(equalTo: centerXAnchor),
            productView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30.scale)
        ])
        
        NSLayoutConstraint.activate([
            buyButton.widthAnchor.constraint(equalToConstant: 183.scale),
            buyButton.heightAnchor.constraint(equalToConstant: 48.scale),
            buyButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            buyButton.topAnchor.constraint(equalTo: productView.bottomAnchor, constant: 30.scale)
        ])
        
        NSLayoutConstraint.activate([
            cancelAnytimeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            cancelAnytimeLabel.topAnchor.constraint(equalTo: buyButton.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? 70.scale : 40.scale)
        ])
        
        NSLayoutConstraint.activate([
            linksLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            linksLabel.topAnchor.constraint(equalTo: cancelAnytimeLabel.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            restoreButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            restoreButton.topAnchor.constraint(equalTo: linksLabel.bottomAnchor, constant: 12.scale),
            restoreButton.heightAnchor.constraint(equalToConstant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            preloader.widthAnchor.constraint(equalToConstant: 45.scale),
            preloader.heightAnchor.constraint(equalToConstant: 45.scale),
            preloader.centerXAnchor.constraint(equalTo: buyButton.centerXAnchor),
            preloader.centerYAnchor.constraint(equalTo: buyButton.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension PaygateView {
    func makeCloseButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "Paygate.Close"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.image = UIImage(named: "Paygate.Image")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.darkGrey)
            .font(Fonts.Inter.regular(size: 12.scale))
            .lineHeight(22.scale)
            .textAlignment(.center)
            .letterSpacing(3.scale)
        
        let view = UILabel()
        view.numberOfLines = 2
        view.attributedText = "Paygate.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeProductView() -> PaygateProductView {
        let view = PaygateProductView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeBuyButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.white)
            .font(Fonts.Inter.regular(size: 12.scale))
            .letterSpacing(1.scale)
        
        let view = UIButton()
        view.setAttributedTitle("Paygate.BuyButton".localized.attributed(with: attrs), for: .normal)
        view.layer.cornerRadius = 24.scale
        view.backgroundColor = Appearance.darkGrey
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCancelAnytimeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.lightGrey)
            .font(Fonts.Inter.regular(size: 12.scale))
            .lineHeight(16.scale)
            .textAlignment(.center)
            .letterSpacing(1.scale)
        
        let view = UILabel()
        view.attributedText = "Paygate.CancelAnytime".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLinksLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.lightGrey)
            .font(Fonts.Inter.regular(size: 12.scale))
            .lineHeight(16.scale)
            .textAlignment(.center)
            .letterSpacing(1.scale)
        
        let string = [
            "Paygate.TermsOfUse".localized,
            "Paygate.&".localized,
            "Paygate.PrivacyPolicy".localized
            ]
            .joined(separator: " ")
            .reduce(NSMutableAttributedString()) { result, string -> NSMutableAttributedString in
                result.append(String(string).attributed(with: attrs))
                return result
            }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(termsAndPolicyTapped(sender:)))
        
        let view = UILabel()
        view.attributedText = string
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeRestoreButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.lightGrey)
            .font(Fonts.Inter.regular(size: 12.scale))
            .letterSpacing(1.scale)
        
        let view = UIButton()
        view.setAttributedTitle("Paygate.Restore".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePreloader() -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        view.color = Appearance.darkGrey
        view.style = .large
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
