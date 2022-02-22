//
//  NFTListCoordinator.swift
//  testApp
//
//  Created by shelin on 2022/2/24.
//

import RxCocoa
import RxSwift
import UIKit

class ProductListCoordinator: Coordinator<NFTCollectionViewModel.FinishReason> {
    
    private let container: AppCoordinatorContainer
    
    init(container: AppCoordinatorContainer) {
        self.container = container
    }

    override func start() -> Observable<NFTCollectionViewModel.FinishReason> {
        let viewModel = NFTCollectionViewModel(apiService: NFTListAPIManager())
        let viewController = NFTCollectionViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)

        container.add(navigationController)

        viewModel.showError
            .subscribe(onNext: {
                let alert = UIAlertController(title: "Error", message: $0.localizedDescription, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)

                alert.addAction(okAction)

                viewController.present(alert, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        return viewModel.didClose.take(1).do(afterNext: { _ in viewController.dismiss(animated: true, completion: nil)})
        
    }
    
    
}
