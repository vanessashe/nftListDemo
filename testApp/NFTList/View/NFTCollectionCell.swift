//
//  NFTCollectionCell.swift
//  nftDemoApp
//
//  Created by shelin on 2022/2/20.
//

import UIKit

class NFTCollectionCell: UICollectionViewCell {
    
    var imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.fixedRatio(1)
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    private let holder = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func initUI() {
        self.contentView.addSubview(holder)
        holder.attach(to: contentView, padding: 5)
        holder.addSubview(imgView)
        holder.addSubview(nameLabel)
        
        imgView.attach(to: holder, top: 12, left: 12, right: -12)
        nameLabel.stickTo(view: imgView, at: .bottom, constant: 20)
        nameLabel.attach(to: holder, left: 12, right: -12)
        
        holder.roundCorner(5)
        holder.backgroundColor = .white
    }
    
    
    
    
}

