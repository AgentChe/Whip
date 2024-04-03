//
//  SessionManager.swift
//  RingSizer
//
//  Created by Андрей Чернышев on 23.03.2024.
//

import RxCocoa
import OtterScaleiOS

protocol SessionManagerProtocol {
    func hasActiveSubscriptions() -> Bool
}

final class SessionManager {}

// MARK: SessionManagerProtocol
extension SessionManager: SessionManagerProtocol {
    func hasActiveSubscriptions() -> Bool {
        guard let paymentData = OtterScale.shared.getPaymentData() else {
            return false
        }

        let subscriptions = paymentData.subscriptions.appleAppStore
            + paymentData.subscriptions.googlePlay
            + paymentData.subscriptions.stripe
            + paymentData.subscriptions.paypal
        let nonConsumables = paymentData.nonConsumables.appleAppStore
            + paymentData.nonConsumables.googlePlay
            + paymentData.nonConsumables.stripe
            + paymentData.nonConsumables.paypal

        let hasValidSubscription = subscriptions.contains(where: { $0.valid })
        let hasValidNonConsumable = nonConsumables.contains(where: { $0.valid })

        return hasValidSubscription || hasValidNonConsumable
    }
}
