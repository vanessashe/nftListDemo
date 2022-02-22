//
//  NFTCollectionViewController.swift
//  nftDemoApp
//
//  Created by shelin on 2022/2/22.
//

import UIKit
import RxSwift
import MapleBacon


class NFTCollectionViewController: UIViewController {
    
    private let viewModel:NFTCollectionViewModel
    private let disposeBag = DisposeBag()
    private var viewWidth: CGFloat {
        get {
            return self.view.frame.width
        }
    }
    private let refreshControl: UIRefreshControl = {
        return UIRefreshControl()
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let itemWidth = viewWidth/2 - 12
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 4/3)
        layout.minimumInteritemSpacing = 4
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(NFTCollectionCell.self, forCellWithReuseIdentifier: NFTCollectionCell.reuseIdentify())
        cv.backgroundColor = 0xf2f2f2.utils.asRGB
        cv.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return cv
    }()
    
    init(viewModel: NFTCollectionViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "NFT Collection"
        initUI()
        initEvent()
        
    }
    
    fileprivate func initUI() {
        
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.attach(to: view, left: 0, right: 0)
        collectionView.attach(toSafeArea: view, top: 0, bottom: 0)
        collectionView.refreshControl = refreshControl
    }
    
        
    
    private func initEvent() {
        
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)

        viewModel.data.bind(to: collectionView.rx.items(cellIdentifier: NFTCollectionCell.reuseIdentify(), cellType: NFTCollectionCell.self)) { (row, element, cell) in
            if let url = URL(string: element.image_url) {
                cell.imgView.setImage(with: url)
            }
            cell.nameLabel.text = element.name
            
        }
        .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(NFTItem.self)
        .subscribe(onNext: { [weak self] nft in
            let viewModel = NFTDetailViewModel(nftItem: nft)
            let vc = NFTDetailViewController(viewModel: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        })
        .disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged).bind(to: viewModel.triggerAPI).disposed(by: disposeBag)

        viewModel.isLoading.bind(to: refreshControl.rx.isRefreshing).disposed(by: disposeBag)
    }
}

extension NFTCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let lastSectionIndex = collectionView.numberOfSections - 1
        let lastRowIndex = collectionView.numberOfItems(inSection: lastSectionIndex) - 1
        
        if indexPath.section == lastSectionIndex && indexPath.row == lastRowIndex {
            viewModel.triggerNextPage.onNext(())
        }
    }

}


fileprivate struct Section {
    var header: String
    var items: [Item]
}
 
extension Section {
    typealias Item = (img: String, name: String)
     
    var identity: String {
        return header
    }
     
    init(original: Section, items: [Item]) {
        self = original
        self.items = items
    }
}
