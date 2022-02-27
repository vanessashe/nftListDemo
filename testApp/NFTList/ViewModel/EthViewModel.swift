//
//  ethViewModel.swift
//  testApp
//
//  Created by shelin on 2022/2/26.
//

import UIKit
import RxSwift
import RxCocoa
import RxSwiftUtilities
import RxSwiftExt

class EthViewModel {

    let apiService: EtheremRPCManager
    let ethBalance: Observable<String>
    
    private let disposeBag = DisposeBag()
    
    init(apiService: EtheremRPCManager) {
        self.apiService = apiService
        let balanceRelay = BehaviorRelay<String>(value: "--")
        ethBalance = balanceRelay.asObservable()
                
        let addr = UserConfig.walletAddr
        apiService.getBalance(of: addr)
            .subscribe { balance in
                balanceRelay.accept("\(balance) ETH")
                
            } onFailure: { err in
                print("error \(err)")
            }.disposed(by: disposeBag)
    
    }
    
    
}

