//
//  WhipsCountView.swift
//  Whip
//
//  Created by Андрей Чернышев on 03.04.2024.
//

import UIKit

final class WhipsCountView: UIView {
    lazy var countLabel = makeLabel()
    lazy var infoLabel = makeInfoLabel()
    lazy var refreshButton = makeRefreshButton()
    
    private lazy var countAttrs = TextAttributes()
        .textColor(Appearance.darkGrey)
        .font(Fonts.Inter.regular(size: 58.scale))
        .lineHeight(70.scale)
        .textAlignment(.center)
    private lazy var infoAttrs = TextAttributes()
        .textColor(Appearance.darkGrey)
        .font(Fonts.Inter.regular(size: 12.scale))
        .lineHeight(20.scale)
        .textAlignment(.center)
        .letterSpacing(3.scale)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension WhipsCountView {
    func setup(count: Int) {
        countLabel.attributedText = String(count).attributed(with: countAttrs)
    }
    
    func setup(secondsLeft: Int) {
        let string = String(format: "Whips.Count.SecondsLeft".localized, secondsLeft)
        infoLabel.attributedText = string.attributed(with: infoAttrs)
    }
    
    func stopped(_ value: Bool) {
        refreshButton.isHidden = !value
    }
}

// MARK: Make constraints
private extension WhipsCountView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            countLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            countLabel.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            infoLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            infoLabel.topAnchor.constraint(equalTo: countLabel.bottomAnchor, constant: 4.scale)
        ])
        
        NSLayoutConstraint.activate([
            refreshButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            refreshButton.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 12.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension WhipsCountView {
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeInfoLabel() -> UILabel {
        let view = UILabel()
        view.attributedText = "Whips.Count.WhipePerMinute".localized.attributed(with: infoAttrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeRefreshButton() -> WhipsRefreshButton {
        let view = WhipsRefreshButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
