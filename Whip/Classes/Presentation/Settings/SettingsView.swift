//
//  SettingsView.swift
//  Whip
//
//  Created by Андрей Чернышев on 02.04.2024.
//

import UIKit

final class SettingsView: UIView {
    lazy var titleLabel = makeTitleLabel()
    lazy var closeButton = makeCloseButton()
    lazy var termsOfUseButton = makeTermsOfUseButton()
    lazy var privacyPolicyButton = makePrivacyPolicyButton()
    lazy var supportButton = makeSupportButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension SettingsView {
    func initialize() {
        backgroundColor = Appearance.darkGrey
    }
}

// MARK: Make constraints
private extension SettingsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 21.scale)
        ])
        
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 44.scale),
            closeButton.heightAnchor.constraint(equalToConstant: 44.scale),
            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            termsOfUseButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            termsOfUseButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            termsOfUseButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 45.scale)
        ])
        
        NSLayoutConstraint.activate([
            privacyPolicyButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            privacyPolicyButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            privacyPolicyButton.topAnchor.constraint(equalTo: termsOfUseButton.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            supportButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            supportButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            supportButton.topAnchor.constraint(equalTo: privacyPolicyButton.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension SettingsView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.white)
            .font(Fonts.Inter.bold(size: 18.scale))
            .lineHeight(26.scale)
            .letterSpacing(3.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "Settings.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCloseButton() -> UIButton {
        let view = UIButton()
        view.setImage(UIImage(named: "Settings.Close"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTermsOfUseButton() -> SettingsLinkButton {
        let view = SettingsLinkButton(
            title: "Settings.TermsOfUse".localized,
            separatorHidden: false,
            url: GlobalDefinitions.termsOfUseUrl
        )
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePrivacyPolicyButton() -> SettingsLinkButton {
        let view = SettingsLinkButton(
            title: "Settings.PrivacyPolicy".localized,
            separatorHidden: false,
            url: GlobalDefinitions.privacyPolicyUrl
        )
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSupportButton() -> SettingsLinkButton {
        let view = SettingsLinkButton(
            title: "Settings.Support".localized,
            separatorHidden: true,
            url: GlobalDefinitions.contactUsUrl
        )
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
