//
//  SettingsLinkButton.swift
//  Whip
//
//  Created by Андрей Чернышев on 03.04.2024.
//

import UIKit
import RxCocoa

final class SettingsLinkButton: UIButton {
    lazy var label = makeTitleLabel()
    lazy var separator = makeSeparator()
    
    private let title: String
    private let separatorHidden: Bool
    private let url: URL
    
    init(title: String, separatorHidden: Bool, url: URL) {
        self.title = title
        self.separatorHidden = separatorHidden
        self.url = url
        
        super.init(frame: .zero)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension SettingsLinkButton {
    var didTap: Signal<URL> {
        rx.tap.asSignal().compactMap { [weak self] in self?.url }
    }
}

// MARK: Make constraints
private extension SettingsLinkButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 26.scale),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -26.scale)
        ])
        
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),
            separator.bottomAnchor.constraint(equalTo: bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension SettingsLinkButton {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.white)
            .font(Fonts.Inter.regular(size: 18.scale))
            .lineHeight(24.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = title.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSeparator() -> UIView {
        let view = UIView()
        view.isHidden = separatorHidden
        view.backgroundColor = Appearance.white
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
