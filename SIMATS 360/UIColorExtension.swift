//
//  UIColorExtension.swift
//  Simats HRMS
//
//  Created by Admin - iMAC on 12/08/24.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex
        hexSanitized = hexSanitized.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}


extension UINavigationBar {
    @objc func updateNavigationBarAppearance(backgroundColor: UIColor? = UIColor(hex:  "#2E3338"), titleColor: UIColor? = nil, titleFont: UIFont? = nil) {
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.shadowColor = .clear
            if let backroundColor = backgroundColor {
                appearance.backgroundColor = backroundColor
            }
            
            var attrs = [NSAttributedString.Key : Any]()
            if let titleColor = titleColor {
                attrs = [
                    NSAttributedString.Key.foregroundColor: titleColor,
                    NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22)
                ]
            }
            let backAppearance = UIBarButtonItemAppearance()
            backAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
            appearance.backButtonAppearance = backAppearance
            appearance.titleTextAttributes = attrs
            standardAppearance = appearance
            scrollEdgeAppearance = appearance
        } else {
      barStyle = .blackTranslucent
      if let backroundColor = backgroundColor {
        barTintColor = backroundColor
      }
      if let titleColor = titleColor {
        titleTextAttributes = [NSAttributedString.Key.foregroundColor: titleColor]
      }
    }
  }
}
