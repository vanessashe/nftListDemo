//
//  NFTDetailViewModel.swift
//  testApp
//
//  Created by shelin on 2022/2/26.
//

import UIKit
import RxSwift
import RxCocoa
import RxSwiftExt

class NFTDetailViewModel {
    
    let nftItem: NFTItem
    let image: Observable<UIImage>
    private let disposeBag = DisposeBag()
    
    init(nftItem: NFTItem) {
        self.nftItem = nftItem
        let imgRelay = BehaviorRelay<UIImage>(value: UIImage())
        image = imgRelay.asObservable()
        
        if let url = URL(string: nftItem.image_url) {
            self.downloadImage(from: url).subscribe { img in
                imgRelay.accept(img ?? UIImage())
            } onFailure: { err in
                
            }.disposed(by: disposeBag)
        }
    }
    
    func downloadImage(from url: URL) -> Single<UIImage?> {
        .create { single -> Disposable in
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                let img = UIImage(data: data)
                DispatchQueue.main.async {
                    single(.success(img))
                }
            }.resume()
            
            return Disposables.create()
            
        }
        
    }
    
}
