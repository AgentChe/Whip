//
//  SettingsViewController.swift
//  Whip
//
//  Created by Андрей Чернышев on 02.04.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class SettingsViewController: UIViewController {
    private lazy var mainView = SettingsView()
    
    private lazy var viewModel = SettingsViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.configure(input: SettingsViewModel.Input(
            didTapClose: mainView.closeButton.rx.tap.asSignal(),
            didTapOpen: Signal.merge(
                mainView.termsOfUseButton.didTap,
                mainView.privacyPolicyButton.didTap,
                mainView.supportButton.didTap
            )
        ))
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension SettingsViewController {
    static func make() -> SettingsViewController {
        let vc = SettingsViewController()
        vc.navigationItem.backButtonTitle = " "
        return vc
    }
}

// MARK: Private
private extension SettingsViewController {
    func route(_ route: SettingsViewModel.Route) {
        switch route {
        case .dismiss:
            navigationController?.popViewController(animated: true)
        case .open(let url):
            UIApplication.shared.open(url)
        }
    }
}
