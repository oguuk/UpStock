//
//  Identifiable.swift
//  UpStock
//
//  Created by 오국원 on 2023/08/21.
//

import Foundation

protocol Identifiable {
    static var identifier: String { get }
}

extension Identifiable {
    static var identifier: String { return "\(self)" }
}
