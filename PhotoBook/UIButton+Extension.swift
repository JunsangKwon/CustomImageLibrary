//
//  UIButton+Extension.swift
//  PhotoBook
//
//  Created by Hhome  on 2022/12/15.
//

import UIKit.UIButton

extension UIButton {
    func alignTextAndImage(spacing: CGFloat = 8.0) {
        titleEdgeInsets = UIEdgeInsets(top: 0, left: -spacing/2, bottom: 0, right: spacing/2)
        imageEdgeInsets = UIEdgeInsets(top: 0, left: spacing/2, bottom: 0, right: -spacing/2)
    }
}
