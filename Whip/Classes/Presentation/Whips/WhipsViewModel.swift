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
        case resetTimer
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
        let didTapRefresh: Signal<Void>
        let didTimeLimit: Signal<Void>
        let didSecondsLeft: Signal<Int>
    }
    
    struct Output {
        let route: Driver<Route>
        let action: Driver<Action>
        let elements: Driver<[WhipsCollectionElement]>
        let count: Driver<Int>
        let isStopped: Driver<Bool>
        let secondsLeft: Driver<Int>
    }
    
    func configure(input: Input) -> Output {
        let activeSubscription = makeActiveSubscription()
        let whips = makeWhips()
        let selectedWhip = makeSelectedWhip(
            didSelectElement: input.didSelectElement,
            whips: whips
        )
        let refresh = makeRefresh(
            didTapRefresh: input.didTapRefresh,
            selectedWhip: selectedWhip
        )
        let isStopped = makeIsStopped(
            didTimeLimit: input.didTimeLimit,
            refresh: refresh
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
                didTapCloseInfo: input.didTapCloseInfo,
                isStopped: isStopped,
                refresh: refresh
            ),
            elements: makeElements(
                activeSubscription: activeSubscription,
                whips: whips
            ),
            count: makeCount(
                didFinishSoundPlaying: input.didFinishSoundPlaying,
                refresh: refresh
            ),
            isStopped: isStopped,
            secondsLeft: input.didSecondsLeft.asDriver(onErrorDriveWith: .never())
        )
    }
}

// MARK: Private
private extension WhipsViewModel {
    func makeRefresh(
        didTapRefresh: Signal<Void>,
        selectedWhip: Driver<Whip>
    ) -> Driver<Void> {
        Driver
            .merge(
                didTapRefresh
                    .asDriver(onErrorDriveWith: .never()),
                selectedWhip
                    .map { _ in Void() }
            )
    }
    
    func makeIsStopped(
        didTimeLimit: Signal<Void>,
        refresh: Driver<Void>
    ) -> Driver<Bool> {
        let stop = didTimeLimit
            .map { true }
            .asDriver(onErrorDriveWith: .never())
        let start = refresh
            .map { false }
            .startWith(false)
        return Driver
            .merge(stop, start)
    }
    
    func makeCount(
        didFinishSoundPlaying: Signal<Void>,
        refresh: Driver<Void>
    ) -> Driver<Int> {
        refresh
            .flatMapLatest {
                didFinishSoundPlaying
                    .asDriver(onErrorDriveWith: .never())
                    .scan(0) { count, void -> Int in
                        count + 1
                    }
                    .startWith(0)
            }
    }
    
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
        didTapCloseInfo: Signal<Void>,
        isStopped: Driver<Bool>,
        refresh: Driver<Void>
    ) -> Driver<Action> {
        let selected = selectedWhip
            .map { Action.selected($0) }
        
        let sound = didMotionShake
            .withLatestFrom(selectedWhip)
            .map { Action.playSound($0.soundName) }
            .asDriver(onErrorDriveWith: .never())
        
        let startAccelerometer = refresh
            .flatMapLatest {
                didFinishSoundPlaying
                    .asDriver(onErrorDriveWith: .never())
                    .withLatestFrom(isStopped)
                    .filter { !$0 }
                    .map { _ in Action.startAccelerometer }
                    .startWith(Action.startAccelerometer)
            }
        
        let infoHidden = Signal
            .merge(
                didTapShowInfo.map { Action.info(false) },
                didTapCloseInfo.map { Action.info(true) }
            )
            .asDriver(onErrorDriveWith: .never())
        
        let resetTimer = refresh
            .map { Action.resetTimer }
        
        return Driver
            .merge(
                selected, sound, startAccelerometer, infoHidden, resetTimer
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
    }
}
