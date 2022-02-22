//
//  NFTCollectionViewModel.swift
//  nftDemoApp
//
//  Created by shelin on 2022/2/22.
//

import UIKit
import RxSwift
import RxCocoa
import RxSwiftUtilities
import RxSwiftExt


class NFTCollectionViewModel {
    enum FinishReason {
        case cancel
    }
    let apiService: NFTLoadingAPIProtocol
    let triggerAPI: AnyObserver<Void>
    let triggerNextPage: AnyObserver<Void>
    
    let didClose: Observable<FinishReason>
    let isLoading: Observable<Bool>
    let data: Observable<[NFTItem]>
    let page: Observable<Int>
    let showError: Observable<Error>
    
    private let disposeBag = DisposeBag()
    
    init(apiService: NFTLoadingAPIProtocol) {
        self.apiService = apiService
        didClose = .never()

        let pageRelay = BehaviorRelay<Int>(value: 1)
        page = pageRelay.asObservable()

        let productListRelay = BehaviorRelay<[NFTItem]>(value: [])
        data = productListRelay.asObservable()

        let indicator = ActivityIndicator()
        isLoading = indicator.asObservable()

        let triggerAPISubject = PublishSubject<Void>()
        triggerAPI = triggerAPISubject.asObserver()

        let triggerNextPageSubject = PublishSubject<Void>()
        triggerNextPage = triggerNextPageSubject.asObserver()

        let fetchProductListResult = triggerAPISubject.asObservable().startWith(())
            .flatMapLatest { _ in apiService.load(page: 1).trackActivity(indicator).materialize() }
            .share()

        fetchProductListResult.elements()
            .bind { products -> Void in
                pageRelay.accept(1)
                productListRelay.accept(products)
            }
            .disposed(by: disposeBag)

        let nextProductListResult = triggerNextPageSubject.asObservable()
            .debounce(.seconds(2), scheduler: MainScheduler.instance)
            .flatMapLatest { _ in apiService.load(page: pageRelay.value+1).trackActivity(indicator).materialize() }
            .share()

        nextProductListResult.elements()
            .bind { products -> Void in
                let newPage = pageRelay.value + 1
                let newData = productListRelay.value + products
                if products.count > 0 {
                    pageRelay.accept(newPage)
                    productListRelay.accept(newData)
                }
            }
            .disposed(by: disposeBag)

        showError = Observable.merge(fetchProductListResult.errors(),
                                     nextProductListResult.errors())
        
    }

}
