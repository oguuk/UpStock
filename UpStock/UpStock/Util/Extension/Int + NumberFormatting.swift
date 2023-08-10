//
//  Int + NumberFormatting.swift
//  UpStock
//
//  Created by 오국원 on 2023/07/31.
//

import Foundation

extension Int {
    
    var formattedWithSeparator: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}
