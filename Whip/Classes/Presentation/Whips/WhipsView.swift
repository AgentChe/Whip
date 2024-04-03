//
//  WhipsView.swift
//  Whip
//
//  Created by Андрей Чернышев on 02.04.2024.
//

import UIKit

final class WhipsView: UIView {
    lazy var titleLabel = makeTitleLabel()
    lazy var settingsButton = makeSettingsButton()
    lazy var whipsCollectionView = makeWhipsCollectonView()
    lazy var nameButton = makeNameButton()
    lazy var descriptionLabel = makeDescriptionLabel()
    lazy var imageView = makeImageView()
    lazy var infoView = makeInfoView()
    
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
extension WhipsView {
    func setup(whip: Whip) {
        nameButton.setup(name: whip.name)
        imageView.image = UIImage(named: whip.largeImageName)
        infoView.setup(whip: whip)
    }
    
    func info(hidden: Bool) {
        nameButton.isHidden = !hidden
        descriptionLabel.isHidden = !hidden
        
        if hidden {
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.infoView.alpha = 0
            }, completion: { [weak self] result in
                self?.infoView.isHidden = true
            })
        } else {
            infoView.isHidden = false
            
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                self?.infoView.alpha = 0.95
            })
        }
    }
}

// MARK: Private
private extension WhipsView {
    func initialize() {
        backgroundColor = Appearance.beige
    }
}

// MARK: Make constraints
private extension WhipsView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 21.scale)
        ])
        
        NSLayoutConstraint.activate([
            settingsButton.widthAnchor.constraint(equalToConstant: 44.scale),
            settingsButton.heightAnchor.constraint(equalToConstant: 44.scale),
            settingsButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            settingsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            whipsCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            whipsCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            whipsCollectionView.heightAnchor.constraint(equalToConstant: 102.scale),
            whipsCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 29.scale)
        ])
        
        NSLayoutConstraint.activate([
            nameButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            nameButton.topAnchor.constraint(equalTo: whipsCollectionView.bottomAnchor, constant: 50.scale)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: nameButton.bottomAnchor, constant: 10.scale)
        ])
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 290.scale),
            imageView.heightAnchor.constraint(equalToConstant: 290.scale),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 14.scale)
        ])
        
        NSLayoutConstraint.activate([
            infoView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            infoView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            infoView.topAnchor.constraint(equalTo: whipsCollectionView.bottomAnchor, constant: 5.scale),
            infoView.heightAnchor.constraint(equalToConstant: 440.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension WhipsView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.darkGrey)
            .font(Fonts.Inter.bold(size: 18.scale))
            .lineHeight(26.scale)
            .letterSpacing(3.scale)
            .textAlignment(.left)
        
        let view = UILabel()
        view.attributedText = "Whips.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSettingsButton() -> UIButton {
        let view = UIButton()
        view.setImage(UIImage(named: "Whips.Settings"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeWhipsCollectonView() -> WhipsCollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12.scale
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: 100.scale, height: 100.scale)
        
        let view = WhipsCollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.clear
        view.contentInset = UIEdgeInsets(horizontal: 146.scale)
        view.showsHorizontalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeNameButton() -> WhipsNameButton {
        let view = WhipsNameButton()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeDescriptionLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.darkGrey)
            .font(Fonts.Inter.regular(size: 12.scale))
            .lineHeight(16.scale)
            .letterSpacing(1.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Whips.Description".localized.attributed(with: attrs)
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
    
    func makeInfoView() -> WhipsInfoView {
        let view = WhipsInfoView()
        view.alpha = 0
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
