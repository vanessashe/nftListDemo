//
//  UITableView+Utils.swift
//  nftDemoApp
//
//  Created by shelin on 2022/2/22.
//

import UIKit

extension UITableViewCell {
    static func reuseIdentify() -> String {
        return String(describing: self)
    }
}
