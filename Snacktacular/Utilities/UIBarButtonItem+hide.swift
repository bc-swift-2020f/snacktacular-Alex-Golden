//
//  UIBarButtonItem+hide.swift
//  Snacktacular
//
//  Created by Alex Golden on 11/10/20.
//

import UIKit

extension UIBarButtonItem {
    func hide() {
        self.isEnabled = false
        self.tintColor = .clear
    }
}
