//
//  MainViewModel.swift
//  Whip
//
//  Created by Андрей Чернышев on 02.04.2024.
//

import RxSwift
import RxCocoa

final class MainViewModel {
    enum Route {
        case settings
    }
}

// MARK: Public
extension MainViewModel {
    struct Input {
        let didTapSettings: Signal<Void>
    }
    
    struct Output {
        let route: Driver<Route>
    }
    
    func configure(input: Input) -> Output {
        Output(
            route: makeRoute(didTapSettings: input.didTapSettings)
        )
    }
}

// MARK: Private
private extension MainViewModel {
    func makeRoute(didTapSettings: Signal<Void>) -> Driver<Route> {
        didTapSettings
            .map { Route.settings }
            .asDriver(onErrorDriveWith: .never())
    }
}
