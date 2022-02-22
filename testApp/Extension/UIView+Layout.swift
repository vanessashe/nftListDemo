//
//  UIView+Layout.swift
//  nftDemoApp
//
//  Created by shelin on 2022/2/20.
//

import UIKit

extension UIView {
        
    func alignCenterX(to view: UIView, constant: CGFloat = 0) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: constant).isActive = true
    }
    func alignCenterY(to view: UIView, constant: CGFloat = 0) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true
    }
    
    func attach(to view: UIView, top: CGFloat? = nil, bottom: CGFloat? = nil, left: CGFloat? = nil, right: CGFloat? = nil) {
        self.translatesAutoresizingMaskIntoConstraints = false
        if let top = top {
            self.topAnchor.constraint(equalTo: view.topAnchor, constant: top).isActive = true
        }
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottom).isActive = true
        }
        if let left = left {
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: left).isActive = true
        }
        if let right = right {
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: right).isActive = true
        }
        
    }
    func attach(toSafeArea view: UIView, top: CGFloat? = nil, bottom: CGFloat? = nil) {
        self.translatesAutoresizingMaskIntoConstraints = false
        if let top = top {
            self.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: top).isActive = true
        }
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: bottom).isActive = true
        }
        
    }
    func attach(to superView: UIView, padding: CGFloat) {
        self.attach(to: superView, top: padding, bottom: -1 * padding, left: padding, right: -1 * padding)
    }
    func attach(to superView: UIView, paddingV: CGFloat, paddingH: CGFloat) {
        self.attach(to: superView, top: paddingV, bottom: -1 * paddingV, left: paddingH, right: -1 * paddingH)
    }
    
    
    
    func stickTo(view: UIView, at position: ViewLayoutPosition, constant: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        switch position {
        case .top:
            self.bottomAnchor.constraint(equalTo: view.topAnchor, constant: constant).isActive = true
        case .bottom:
            self.topAnchor.constraint(equalTo: view.bottomAnchor, constant: constant).isActive = true
        case .left:
            self.trailingAnchor.constraint(equalTo: view.leadingAnchor, constant: constant).isActive = true
        case .right:
            self.leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: constant).isActive = true
        }
    }
    
    func equalWidth(_ constant: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        let cons = self.widthAnchor.constraint(equalToConstant: constant)
        cons.isActive = true
    }
    
    func equalHeight(_ constant: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        let cons = self.heightAnchor.constraint(equalToConstant: constant)
        cons.isActive = true
    }
    
    func fixedRatio(_ ratio: CGFloat) {
        
        self.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: ratio).isActive = true
    }
    
    
    func setProgrammable() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
}
enum ViewLayoutPosition {
    case top
    case bottom
    case left
    case right
}
