//
//  UILabel+Extension.swift
//  The Weather
//
//  Created by Дмитрий Скок on 14.04.2023.
//

import Foundation
import UIKit

extension UILabel {
    convenience init(text: String, font: UIFont?, textAlignment: NSTextAlignment = .natural) {
        self.init()
        self.text = text
        self.font = font
        self.textColor = UIColor.white
        self.textAlignment = textAlignment
    }
}
