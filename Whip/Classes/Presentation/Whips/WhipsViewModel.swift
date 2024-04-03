//
//  WhipsViewModel.swift
//  Whip
//
//  Created by Андрей Чернышев on 02.04.2024.
//

import RxSwift
import RxCocoa

final class WhipsViewModel {
    enum Route {
        case settings, paygate
    }
    
    enum Action {
        case selected(Whip)
        case playSound(String)
        case startAccelerometer
        case info(Bool)
    }
    
    private lazy var contentManager = ContentManager()
}

// MARK: Public
extension WhipsViewModel {
    struct Input {
        let didTapSettings: Signal<Void>
        let didSelectElement: Signal<WhipsCollectionElement>
        let didMotionShake: Signal<Void>
        let didFinishSoundPlaying: Signal<Void>
        let didTapShowInfo: Signal<Void>
        let didTapCloseInfo: Signal<Void>
    }
    
    struct Output {
        let route: Driver<Route>
        let action: Driver<Action>
        let elements: Driver<[WhipsCollectionElement]>
    }
    
    func configure(input: Input) -> Output {
        let activeSubscription = makeActiveSubscription()
        let whips = makeWhips()
        let selectedWhip = makeSelectedWhip(
            didSelectElement: input.didSelectElement,
            whips: whips
        )
        
        return Output(
            route: makeRoute(
                didTapSettings: input.didTapSettings,
                didSelectElement: input.didSelectElement
            ),
            action: makeAction(
                selectedWhip: selectedWhip,
                didMotionShake: input.didMotionShake,
                didFinishSoundPlaying: input.didFinishSoundPlaying,
                didTapShowInfo: input.didTapShowInfo,
                didTapCloseInfo: input.didTapCloseInfo
            ),
            elements: makeElements(
                activeSubscription: activeSubscription,
                whips: whips
            )
        )
    }
}

// MARK: Private
private extension WhipsViewModel {
    func makeRoute(
        didTapSettings: Signal<Void>,
        didSelectElement: Signal<WhipsCollectionElement>
    ) -> Driver<Route> {
        let settings = didTapSettings
            .map { Route.settings }
            .asDriver(onErrorDriveWith: .never())
        
        let paygate = didSelectElement
            .compactMap { element -> Route? in
                element.needPayment ? .paygate : nil
            }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(settings, paygate)
    }
    
    func makeAction(
        selectedWhip: Driver<Whip>,
        didMotionShake: Signal<Void>,
        didFinishSoundPlaying: Signal<Void>,
        didTapShowInfo: Signal<Void>,
        didTapCloseInfo: Signal<Void>
    ) -> Driver<Action> {
        let selected = selectedWhip
            .map { Action.selected($0) }
        
        let sound = didMotionShake
            .withLatestFrom(selectedWhip)
            .map { Action.playSound($0.soundName) }
            .asDriver(onErrorDriveWith: .never())
        
        let startAccelerometer = didFinishSoundPlaying
            .map { Action.startAccelerometer }
            .startWith(Action.startAccelerometer)
            .asDriver(onErrorDriveWith: .never())
        
        let infoHidden = Signal
            .merge(
                didTapShowInfo.map { Action.info(false) },
                didTapCloseInfo.map { Action.info(true) }
            )
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(
                selected, sound, startAccelerometer, infoHidden
            )
    }
    
    func makeSelectedWhip(
        didSelectElement: Signal<WhipsCollectionElement>,
        whips: Driver<[Whip]>
    ) -> Driver<Whip> {
        let initial = whips
            .compactMap { $0.first(where: { !$0.paid } ) }
        
        let select = didSelectElement
            .asDriver(onErrorDriveWith: .never())
            .map { $0.whip }
        
        return Driver
            .merge(initial, select)
            .distinctUntilChanged()
    }
    
    func makeElements(
        activeSubscription: Driver<Bool>,
        whips: Driver<[Whip]>
    ) -> Driver<[WhipsCollectionElement]> {
        Driver
            .combineLatest(
                activeSubscription,
                whips
            )
            .map { activeSubscription, whips -> [WhipsCollectionElement] in
                whips.enumerated().map { index, whip -> WhipsCollectionElement in
                    WhipsCollectionElement(
                        whip: whip,
                        needPayment: whip.paid ? !activeSubscription : false,
                        marked: index == 0
                    )
                }
            }
    }
    
    func makeWhips() -> Driver<[Whip]> {
        contentManager
            .obtainWhips()
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeActiveSubscription() -> Driver<Bool> {
        PurchaseValidationObserver.shared
            .didValidatedWithActiveSubscription
            .map { SessionManager().hasActiveSubscriptions() }
            .startWith(SessionManager().hasActiveSubscriptions())
            .asDriver(onErrorJustReturn: false)
            .map { _ in true } // TODO
    }
}
