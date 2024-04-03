//
//  ContentManager.swift
//  Whip
//
//  Created by Андрей Чернышев on 03.04.2024.
//

import RxSwift

protocol ContentManagerProtocol {
    func obtainWhips() -> Single<[Whip]>
}

final class ContentManager {}

// MARK: ContentManagerProtocol
extension ContentManager: ContentManagerProtocol {
    func obtainWhips() -> Single<[Whip]> {
        Single<[Whip]>.create { single in
            let whips = [
                Whip(
                    name: "Whip.Bull.Name".localized,
                    soundName: "bullwhip",
                    largeImageName: "Whip.Bull.Large",
                    smallImageName: "Whip.Bull.Small",
                    description: "Whip.Bull.Description".localized,
                    paid: false
                ),
                
                Whip(
                    name: "Whip.Horse.Name".localized,
                    soundName: "horsewhip",
                    largeImageName: "Whip.Horse.Large",
                    smallImageName: "Whip.Horse.Small",
                    description: "Whip.Horse.Description".localized,
                    paid: true
                ),
                
                Whip(
                    name: "Whip.Lash.Name".localized,
                    soundName: "lashwhip",
                    largeImageName: "Whip.Lash.Large",
                    smallImageName: "Whip.Lash.Small",
                    description: "Whip.Lash.Description".localized,
                    paid: true
                ),
                
                Whip(
                    name: "Whip.Snake.Name".localized,
                    soundName: "snakewhip",
                    largeImageName: "Whip.Snake.Large",
                    smallImageName: "Whip.Snake.Small",
                    description: "Whip.Snake.Description".localized,
                    paid: true
                ),
                
                Whip(
                    name: "Whip.Stock.Name".localized,
                    soundName: "stockwhip",
                    largeImageName: "Whip.Stock.Large",
                    smallImageName: "Whip.Stock.Small",
                    description: "Whip.Stock.Description".localized,
                    paid: true
                )
            ]
            
            single(.success(whips))
            
            return Disposables.create()
        }
    }
}
