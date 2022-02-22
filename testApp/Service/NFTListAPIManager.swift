//
//  NFTListAPI.swift
//  nftDemoApp
//
//  Created by shelin on 2022/2/22.
//

import UIKit
import RxSwift
import RxAlamofire
import Alamofire

protocol NFTLoadingAPIProtocol {
    func load(page: Int) -> Single<[NFTItem]>
}

class NFTListAPIManager:ApiManager, NFTLoadingAPIProtocol {
    
    func load(page: Int) -> Single<[NFTItem]> {
        
        .create { (single) -> Disposable in
            
            let limit:Int = 50
            let param:Parameters = [
                "owner" : "0x960DE9907A2e2f5363646d48D7FB675Cd2892e91",
                "format": "json",
                "cursor": (page - 1) * limit,
                "offset": (page - 1) * limit,
                "limit": limit
            ]
            
            let url = "https://api.opensea.io/api/v1/assets"
            let headers:HTTPHeaders = ["X-API-KEY": "5b294e9193d240e39eefc5e6e551ce83"]
            self.requestWithQueryParameters(url, method: .get, parameters: param, headers: headers) { (response) in
                
                guard let res = response as? [String:Any], let assets = res["assets"] as? [[String:Any]] else {
                    return
                }
                DispatchQueue.main.async {
                    let data = assets.compactMap { NFTItem.create(by: $0)}

                    single(.success(data))
                }

            } onError: { (error) in
                single(.failure(error))
            }

            return Disposables.create()
        }
        
    }
    
    
}

class ApiManager: NSObject {
    static let shared = ApiManager()
    
    fileprivate let disposeBag = DisposeBag()
    

    internal func request(_ apiPath:String,
                         method: HTTPMethod,
                         auth: Bool? = true,
                         headers: HTTPHeaders? = nil,
                         onNext: ((Any) -> Void)? = nil,
                         onError: ((Error) -> Void)? = nil
    ) {

        return RxAlamofire.requestJSON(method, apiPath, parameters: nil, encoding: URLEncoding.default, headers: headers, interceptor: nil)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { (response, data) in
                if let data = data as? Dictionary<String,AnyObject> {
                    if let error = data["error"] {
                        var err = (error as? Dictionary<String,AnyObject>) ?? [:]
                        err["statusCode"] = response.statusCode as AnyObject
                        onError?(ApiError(data: err))
                        return
                    }
                }
                onNext?(data)
            }, onError: { error in
                onError?(error)
            }).disposed(by: disposeBag)
    }
    
   
    
    internal func requestWithQueryParameters(_ apiPath:String,
                         method: HTTPMethod,
                         auth: Bool? = true,
                         parameters:Parameters ,
                         headers: HTTPHeaders? = nil,
                         onNext: ((Any) -> Void)? = nil,
                         onError: ((Error) -> Void)? = nil
    ) {
        var urlParams:String = parameters.compactMap({ (key, value) -> String in
            return "\(key)=\(value)"
        }).joined(separator: "&")
        urlParams = urlParams.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            .replacingOccurrences(of: "+", with: "%2B")

        let req = RxAlamofire.requestJSON(method, apiPath, parameters: parameters, encoding: URLEncoding.default, headers: headers, interceptor: nil)
        
        return req.observe(on: MainScheduler.instance)
            .subscribe(onNext: { (response, data) in
                
                if let data = data as? Dictionary<String,AnyObject> {
                    if let error = data["error"] {
                        var err = (error as? Dictionary<String,AnyObject>) ?? [:]
                        err["statusCode"] = response.statusCode as AnyObject
                        onError?(ApiError(data: err))
                        return
                    }
                }
                onNext?(data)
            }, onError: { error in
                onError?(error)
            }).disposed(by: disposeBag)

    }
}
class ApiError: NSObject, Error {
    var data:Dictionary<String,AnyObject>?
    
    init(data:Dictionary<String,AnyObject>) {
        super.init()
        
        self.data = data
    }
    
    override var description: String {
        return self.data?.description ?? "No information"
    }
    
    func getErrorData() -> Dictionary<String,AnyObject> {
        return data ?? [:]
    }
}



