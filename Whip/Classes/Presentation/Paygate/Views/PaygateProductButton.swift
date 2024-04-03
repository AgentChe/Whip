//
//  PaygateProductButton.swift
//  RingSizer
//
//  Created by Андрей Чернышев on 25.03.2024.
//

import UIKit

final class PaygateProductView: UIView {
    lazy var freePeriodLabel = makeFreePeriodLabel()
    lazy var priceLabel = makeLabel()
    
    private lazy var priceAttrs = TextAttributes()
        .textColor(Appearance.darkGrey)
        .font(Fonts.Inter.bold(size: 12.scale))
        .lineHeight(22.scale)
        .letterSpacing(3.scale)
        .textAlignment(.center)
    
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
extension PaygateProductView {
    func setup(product: ProductPrice) {
        guard let price = Currency(productPrice: product).formatted() else {
            return
        }
        
        let string = String(format: "Paygate.Price".localized, price)
        priceLabel.attributedText = string.attributed(with: priceAttrs)
    }
}

// MARK: Make constraints
private extension PaygateProductView {
    func initialize() {
        backgroundColor = Appearance.white
        layer.cornerRadius = 12.scale
        layer.borderWidth = 1.scale
        layer.borderColor = Appearance.darkGrey.cgColor
    }
}

// MARK: Make constraints
private extension PaygateProductView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            freePeriodLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            freePeriodLabel.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -2.scale)
        ])
        
        NSLayoutConstraint.activate([
            priceLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            priceLabel.topAnchor.constraint(equalTo: centerYAnchor, constant: 2.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension PaygateProductView {
    func makeFreePeriodLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.darkGrey)
            .font(Fonts.Inter.regular(size: 12.scale))
            .lineHeight(22.scale)
            .letterSpacing(3.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Paygate.FreePeriod".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
