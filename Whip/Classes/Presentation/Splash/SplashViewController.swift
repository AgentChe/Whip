//
//  SplashViewController.swift
//  Soccer
//
//  Created by Андрей Чернышев on 05.07.2022.
//

import UIKit
import RxSwift
import Lottie

final class SplashViewController: UIViewController {
    private lazy var mainView = SplashView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var sdkInitialize = SplashReceiptValidationObserver()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sdkInitialize.observe { [weak self] in
            self?.route()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        startAnimation()
    }
}

// MARK: Make
extension SplashViewController {
    static func make() -> SplashViewController {
        SplashViewController()
    }
}

// MARK: Private
private extension SplashViewController {
    func startAnimation() {
        mainView.animationView.animation = LottieAnimation.named("Splash.Animate")
        mainView.animationView.play()
    }
    
    func route() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) { [weak self] in
            self?.goNext()
        }
    }
    
    func goNext() {
        if !OnboardingViewController.wasViewed() {
            UIApplication.shared.keyWindow?.rootViewController = OnboardingViewController.make()
            return
        }
        
        let nc = NavigationController(rootViewController: WhipsViewController.make(requestReview: false))
        nc.setNavigationBarHidden(true, animated: false)
        
        if SessionManager().hasActiveSubscriptions() {
            UIApplication.shared.keyWindow?.rootViewController = nc
        } else {
            let vc = PaygateViewController.make {
                UIApplication.shared.keyWindow?.rootViewController = nc
            }
            present(vc, animated: true)
        }
    }
}
