//
//  BalanceView.swift
//  testApp
//
//  Created by shelin on 2022/2/27.
//

import UIKit

class BalanceView:UIView {
    let contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = 0x767676.utils.asRGB
        label.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        label.textAlignment = .center
        label.minimumScaleFactor = 0.4
        label.numberOfLines = 2
        
        return label
    }()
    private let titleLabel:UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.text = "Account Balance"
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initUI() {
        self.addSubview(titleLabel)
        titleLabel.alignCenterX(to: self)
        titleLabel.alignCenterY(to: self, constant: -25)
        self.addSubview(contentLabel)
        contentLabel.stickTo(view: titleLabel, at: .bottom, constant: 10)
        contentLabel.attach(to: self, left: 16, right: -16)
    }
    
}
