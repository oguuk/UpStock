//
//  UpbitAPIManager.swift
//  UpStock
//
//  Created by 오국원 on 2023/07/28.
//

import Foundation
import RxSwift

final class UpbitAPIManager {
    
    enum Constant {
        static let baseURL: String = "https://api.upbit.com/v1"
        static let pathOfCheckMarketCode = "/market/all"
        static let pathOfCurrentPrice = "/ticker"
    }
    
    private let disposeBag = DisposeBag()
    
