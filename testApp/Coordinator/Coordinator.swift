//
//  Coordinator.swift
//  testApp
//
//  Created by shelin on 2022/2/24.
//

import UIKit
import RxSwift

class Coordinator<ResultType> {

    typealias CoordinationResult = ResultType

    let disposeBag = DisposeBag()

    private let identifier = UUID()

    private var childCoordinators = [UUID: Any]()

    private func store<T>(coordinator: Coordinator<T>) {
        childCoordinators[coordinator.identifier] = coordinator
    }

    private func free<T>(coordinator: Coordinator<T>) {
        childCoordinators[coordinator.identifier] = nil
    }

    func coordinate<T>(to coordinator: Coordinator<T>) -> Observable<T> {
        store(coordinator: coordinator)
        return coordinator.start()
            .do(onNext: { [weak self] _ in self?.free(coordinator: coordinator) })
    }

    func start() -> Observable<ResultType> {
        fatalError("Start method should be implemented.")
    }
}

// MARK: - AppCoordinatorContainer

public class AppCoordinatorContainer {

    private let container: UIViewController

    public init(with appRootViewController: UIViewController) {
        container = appRootViewController
    }

    public func add(_ child: UIViewController) {
        child.view.frame = container.view.bounds
        container.addChild(child)
        UIView.transition(with: container.view,
                          duration: 0.15,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
                            self?.container.view.addSubview(child.view)
            }, completion: nil)
        container.view.addSubview(child.view)
        child.didMove(toParent: container)
    }

    public func remove(_ child: UIViewController) {
        container.dismiss(animated: true, completion: nil)

        container.didMove(toParent: nil)
        child.removeFromParent()
        child.view.removeFromSuperview()
    }

}

