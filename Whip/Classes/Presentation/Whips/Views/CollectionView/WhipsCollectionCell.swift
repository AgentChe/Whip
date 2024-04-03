//
//  WhipsCollectionCell.swift
//  Whip
//
//  Created by Андрей Чернышев on 03.04.2024.
//

import UIKit

final class WhipsCollectionCell: UICollectionViewCell {
    lazy var container = makeContainer()
    lazy var imageView = makeImageView()
    lazy var lockView = makeLockView()
    
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
extension WhipsCollectionCell {
    func setup(element: WhipsCollectionElement) {
        container.layer.borderColor = element.marked ? Appearance.darkGrey.cgColor : Appearance.white.cgColor
        imageView.image = UIImage(named: element.whip.smallImageName)
        lockView.isHidden = !element.needPayment
    }
}

// MARK: Private
private extension WhipsCollectionCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.clear
        selectedBackgroundView = selectedView
    }
}

// MARK: Make constraints
private extension WhipsCollectionCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: container.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            lockView.widthAnchor.constraint(equalToConstant: 24.scale),
            lockView.heightAnchor.constraint(equalToConstant: 24.scale),
            lockView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -5.scale),
            lockView.topAnchor.constraint(equalTo: container.topAnchor, constant: 2.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension WhipsCollectionCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.layer.borderWidth = 4.scale
        view.layer.cornerRadius = 50.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.layer.cornerRadius = 50.scale
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeLockView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Whips.Lock")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
