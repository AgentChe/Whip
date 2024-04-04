//
//  WhipsRefreshButton.swift
//  Whip
//
//  Created by Андрей Чернышев on 03.04.2024.
//

import UIKit

final class WhipsRefreshButton: UIButton {
    lazy var iconView = makeIconView()
    lazy var label = makeLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension WhipsRefreshButton {
    func initialize() {
        backgroundColor = UIColor.clear
        layer.cornerRadius = 14.scale
        layer.borderWidth = 1.scale
        layer.borderColor = Appearance.darkGrey.cgColor
    }
}

// MARK: Make constraints
private extension WhipsRefreshButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 14.scale),
            iconView.heightAnchor.constraint(equalToConstant: 14.scale),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10.scale)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30.scale),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10.scale),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 6.scale),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension WhipsRefreshButton {
    func makeIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Whips.Refresh")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.darkGrey)
            .font(Fonts.Inter.regular(size: 12.scale))
            .lineHeight(16.scale)
            .letterSpacing(1.scale)
        
        let view = UILabel()
        view.attributedText = "Whips.Count.Refresh".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
