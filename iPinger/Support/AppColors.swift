//
//  AppColors.swift
//  iPinger
//
//  Created by Jose Bolivar on 7/12/20.
//

import Foundation
import UIKit

enum AssetsColor: String {
    case mainColor = "AppBarColor"
    case greenColor = "AppGreenColor"
    case blueColor = "AppBlueColor"
    case redColor = "AppRedColor"
}

extension UIColor {
    static func appColor(_ name: AssetsColor) -> UIColor? {
        return UIColor(named: name.rawValue)
    }
}
