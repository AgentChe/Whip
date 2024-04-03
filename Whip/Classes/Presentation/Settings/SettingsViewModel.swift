//
//  SettingsViewModel.swift
//  Whip
//
//  Created by Андрей Чернышев on 02.04.2024.
//

import RxSwift
import RxCocoa

final class SettingsViewModel {
    enum Route {
        case dismiss, open(URL)
    }
}

// MARK: Public
extension SettingsViewModel {
    struct Input {
        let didTapClose: Signal<Void>
        let didTapOpen: Signal<URL>
    }
    
    struct Output {
        let route: Driver<Route>
    }
    
    func configure(input: Input) -> Output {
        Output(
            route: makeRoute(
                didTapClose: input.didTapClose,
                didTapOpen: input.didTapOpen
            )
        )
    }
}

// MARK: Private
private extension SettingsViewModel {
    func makeRoute(
        didTapClose: Signal<Void>,
        didTapOpen: Signal<URL>
    ) -> Driver<Route> {
        let close = didTapClose
            .asDriver(onErrorDriveWith: .never())
            .map { Route.dismiss }
        
        let open = didTapOpen
            .asDriver(onErrorDriveWith: .never())
            .map { Route.open($0) }
        
        return Driver
            .merge(close, open)
    }
}
