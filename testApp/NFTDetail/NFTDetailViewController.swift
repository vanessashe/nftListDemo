//
//  NFTDetailViewController.swift
//  testApp
//
//  Created by shelin on 2022/2/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxSwiftExt

fileprivate let viewWidth = UIScreen.main.bounds.width

class NFTDetailViewController: UIViewController {
    
    private let viewModel: NFTDetailViewModel
    private let disposeBag = DisposeBag()
    
    private var imageHeight: NSLayoutConstraint?
    private let permaLinkButton: UIButton = {
        
        let btn = UIButton()
        btn.backgroundColor = 0x1336bf.utils.asRGB
        btn.setTitle("permalink", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.equalHeight(50)
        btn.roundCorner(5)
        return btn
        
    }()
    
    private let imageView: UIImageView = {
        
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    private let imageBackgroundView: UIView = {
        let v = UIView()
        v.backgroundColor = 0xf0f0f0.utils.asRGB
        return v
    }()
    
    private let indicator = UIActivityIndicatorView()
    
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private let descTextView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 15)
        tv.textColor = .black
        tv.isScrollEnabled = false
        return tv
    }()
    
    lazy private var scrollView:UIScrollView = {
        let sv = UIScrollView()
        sv.showsHorizontalScrollIndicator = false
        sv.contentSize = view.frame.size
        return sv
    }()
    
    private let scrollContentView = UIView()
    init(viewModel: NFTDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        setUIContent()

    }
    
    fileprivate func initUI() {
        let padding:CGFloat = 16
        
        view.addSubview(scrollView)
        scrollView.attach(to: view, left: 0, right: 0)
        scrollView.attach(toSafeArea: view, top: 0, bottom: -70)
        
        scrollView.addSubview(scrollContentView)
        scrollContentView.equalWidth(viewWidth)
        scrollContentView.alignCenterX(to: scrollView)

        scrollContentView.addSubview(imageBackgroundView)
        scrollContentView.addSubview(imageView)
        imageView.attach(to: scrollContentView, top: 30)
        imageView.equalWidth(viewWidth - padding * 2)
        imageView.alignCenterX(to: scrollContentView)
        imageHeight = imageView.heightAnchor.constraint(equalToConstant: 90)
        imageHeight?.isActive = true
        
        imageBackgroundView.attach(to: imageView, padding: 0)
        imageBackgroundView.addSubview(indicator)
        indicator.alignCenterX(to: imageBackgroundView)
        indicator.alignCenterY(to: imageBackgroundView)
        indicator.startAnimating()
        
        
        scrollContentView.addSubview(nameLabel)
        nameLabel.attach(to: scrollContentView, left: padding, right: padding * -1)
        nameLabel.stickTo(view: imageView, at: .bottom, constant: 30)
        
        scrollContentView.addSubview(descTextView)
        descTextView.attach(to: scrollContentView, bottom: -30, left: padding, right: padding * -1)
        descTextView.stickTo(view: nameLabel, at: .bottom, constant: 20)
        descTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
        
        
        view.addSubview(permaLinkButton)
        permaLinkButton.attach(to: view, left: padding, right: padding * -1)
        permaLinkButton.attach(toSafeArea: view, bottom: padding * -1)
        
        view.backgroundColor = .white
        
    }
    
    private func setUIContent() {
        navigationItem.title = viewModel.nftItem.collectionName
        
        viewModel.image.bind(to: imageView.rx.image).disposed(by: disposeBag)
        viewModel.image
            .subscribe { img in
                self.didReceiveImage(img.element)
                
            }.disposed(by: disposeBag)
        
        
        nameLabel.text = viewModel.nftItem.name
        descTextView.text = viewModel.nftItem.desc
        descTextView.sizeToFit()
        resizeScrollView()
        
        permaLinkButton.rx.tap
            .subscribe(onNext: {
                self.openPermalink()
            })
            .disposed(by: disposeBag)
        
    }
    
    private func resizeImageView() {
        guard let img = imageView.image?.cgImage else {
            return
        }
        imageHeight?.constant = (viewWidth - 32) * CGFloat(img.height) / CGFloat(img.width)
        view.layoutIfNeeded()
    }
    
    private func resizeScrollView() {
        let h = max(scrollContentView.frame.maxY + 40, descTextView.frame.maxY + 40)
        scrollView.contentSize = CGSize(width: viewWidth, height: h)
    }
    
    private func stopIndicator() {
        indicator.stopAnimating()
        imageBackgroundView.isHidden = true
    }
    
    private func didReceiveImage(_ image: UIImage?) {
        guard let _ = image else {
            return
        }
        resizeImageView()
        resizeScrollView()
        stopIndicator()
    }
    
    
    private func openPermalink() {
        guard let url = URL(string: viewModel.nftItem.permalink) else {
            return
        }
        
        guard UIApplication.shared.canOpenURL(url) else {
            return
        }
        
        UIApplication.shared.open(url, options: [:])
        
    }
    
    
}

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
