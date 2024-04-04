//
//  WhipsViewController.swift
//  Whip
//
//  Created by Андрей Чернышев on 02.04.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class WhipsViewController: UIViewController {
    private lazy var mainView = WhipsView()
    
    private lazy var viewModel = WhipsViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var player = WhipSoundPlayer()
    private lazy var motionShake = WhipMotionShake()
    private lazy var timer = WhipsTimer()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.configure(input: WhipsViewModel.Input(
            didTapSettings: mainView.settingsButton.rx.tap.asSignal(),
            didSelectElement: mainView.whipsCollectionView.didSelect,
            didMotionShake: motionShake.didMotionShake,
            didFinishSoundPlaying: player.didFinishPlaying,
            didTapShowInfo: mainView.nameButton.rx.tap.asSignal(),
            didTapCloseInfo: mainView.infoView.closeButton.rx.tap.asSignal(),
            didTapRefresh: mainView.countView.refreshButton.rx.tap.asSignal(),
            didTimeLimit: timer.didTimeLimit,
            didSecondsLeft: timer.didSecondsLeft
        ))
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
        
        output.action
            .drive(Binder(self) { base, action in
                base.action(action)
            })
            .disposed(by: disposeBag)
        
        output.elements
            .drive(Binder(mainView.whipsCollectionView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        output.count
            .drive(Binder(mainView.countView) { base, count in
                base.setup(count: count)
            })
            .disposed(by: disposeBag)
        
        output.isStopped
            .drive(Binder(mainView.countView) { base, isStopped in
                base.stopped(isStopped)
            })
            .disposed(by: disposeBag)
        
        output.secondsLeft
            .drive(Binder(mainView.countView) { base, secondsLeft in
                base.setup(secondsLeft: secondsLeft)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension WhipsViewController {
    static func make() -> WhipsViewController {
        let vc = WhipsViewController()
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: Private
private extension WhipsViewController {
    func route(_ route: WhipsViewModel.Route) {
        switch route {
        case .settings:
            let vc = SettingsViewController.make()
            navigationController?.pushViewController(vc, animated: true)
        case .paygate:
            let vc = PaygateViewController.make()
            present(vc, animated: true)
        }
    }
    
    func action(_ action: WhipsViewModel.Action) {
        switch action {
        case .selected(let whip):
            mainView.setup(whip: whip)
        case .playSound(let name):
            player.play(soundName: name)
        case .startAccelerometer:
            motionShake.startAccelerometer()
        case .info(let hidden):
            mainView.info(hidden: hidden)
        case .resetTimer:
            timer.reset()
        }
    }
}
