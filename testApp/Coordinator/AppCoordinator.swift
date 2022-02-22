//
//  AppCoordinator.swift
//  testApp
//
//  Created by shelin on 2022/2/24.
//

import UIKit
import RxSwift
import RxCocoa

class AppCoordinator: Coordinator<Void> {

    private enum State {

        case main

    }

    private weak var window: UIWindow!

    private let state = PublishRelay<State>()

    private lazy var rootViewController = UIViewController()

    private lazy var container = AppCoordinatorContainer(with: rootViewController)


    init(with window: UIWindow) {
        self.window = window
        window.makeKeyAndVisible()

        super.init()

        state
            .subscribe(onNext: { [unowned self] (state) in
                switch state {
                case .main:
                    self.showMain()
                }
            })
            .disposed(by: disposeBag)
    }

    override func start() -> Observable<Void> {
        window.rootViewController = rootViewController

        state.accept(.main)
        return .never()
    }

}

private extension AppCoordinator {

    func showMain() {
        let coordinator = ProductListCoordinator(container: container)

        coordinate(to: coordinator)
            .map { _ in .main }
            .bind(to: state)
            .disposed(by: disposeBag)
    }
}



