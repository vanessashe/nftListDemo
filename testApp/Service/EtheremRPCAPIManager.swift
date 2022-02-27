//
//  EtheremRPCAPIManager.swift
//  testApp
//
//  Created by shelin on 2022/2/26.
//

import UIKit
import Web3
import Web3PromiseKit
import RxSwift

class EtheremRPCManager:NSObject {
    
    func getBalance(of addrStr: String) -> Single<Double> {
        .create { (single) -> Disposable in
            let web3 = Web3(rpcURL: "https://8e800f6c17ac43cdb911b95b09e592f3.eth.rpc.rivet.cloud/")
            do {
                let addr = try EthereumAddress(hex: addrStr, eip55: true)
                web3.eth.getBalance(address: addr, block: EthereumQuantityTag.latest) { resp in
                    print("resp \(resp)")
                    guard let q = resp.result?.quantity else {
                        return
                    }
                    let unit: BigInt = 1
                    let num = Double(q)/Double(unit.eth)
                                        
                    single(.success(num))
                    
                }
            } catch {
                print("error \(error)")
                single(.failure(error))
            }

            return Disposables.create()
        }
        
    }

}





