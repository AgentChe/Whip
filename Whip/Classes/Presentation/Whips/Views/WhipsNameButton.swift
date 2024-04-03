//
//  WhipsNameButton.swift
//  Whip
//
//  Created by Андрей Чернышев on 03.04.2024.
//

import UIKit

final class WhipsNameButton: UIView {
    lazy var label = makeLabel()
    lazy var infoView = makeInfoView()
    
    private lazy var attrs = TextAttributes()
        .textColor(Appearance.darkGrey)
        .font(Fonts.Inter.bold(size: 18.scale))
        .lineHeight(26.scale)
        .textAlignment(.left)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension WhipsNameButton {
    func setup(name: String) {
        label.attributedText = name.attributed(with: attrs)
    }
}

// MARK: Make constraints
private extension WhipsNameButton {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -29.scale),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            label.widthAnchor.constraint(lessThanOrEqualToConstant: 270.scale)
        ])
        
        NSLayoutConstraint.activate([
            infoView.widthAnchor.constraint(equalToConstant: 24.scale),
            infoView.heightAnchor.constraint(equalToConstant: 24.scale),
            infoView.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 5.scale),
            infoView.centerYAnchor.constraint(equalTo: label.centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension WhipsNameButton {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeInfoView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Whips.Info")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
