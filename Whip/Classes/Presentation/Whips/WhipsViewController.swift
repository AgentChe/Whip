//
//  WhipsViewController.swift
//  Whip
//
//  Created by Андрей Чернышев on 02.04.2024.
//

import UIKit
import RxSwift

final class WhipsViewController: UIViewController {
    private lazy var mainView = WhipsView()
    
    private lazy var viewModel = WhipsViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.configure(input: WhipsViewModel.Input(
            didTapSettings: mainView.settingsButton.rx.tap.asSignal(),
            didSelectElement: mainView.whipsCollectionView.didSelect
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
        }
    }
}
