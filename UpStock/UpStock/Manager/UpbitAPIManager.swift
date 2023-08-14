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
    
    func fetchTicker<T: Codable>(markets: String) -> Observable<[T]?> {
        return Observable.create { observer in
            let disposable = Network.default.get(url: Constant.baseURL + Constant.pathOfCurrentPrice, parameters: ["markets":markets])
                .subscribe(onNext: { result in
                    switch result {
                    case let .success(data):
                        print("DEBUG : \(String(data: data ?? Data(), encoding: .utf8))")
                        self.handleSuccess(data: data, observer: observer)
                    case let .failure(error):
                        print("\(markets) error \(error.localizedDescription)")
                        observer.onError(error)
                    }
                })
            
            return Disposables.create { disposable.dispose() }
        }
    }
    
    func fetchUpbitTradableMarkets() -> Observable<[Market]?> {
        return Observable.create { observer in
            let disposable = Network.default.get(url: Constant.baseURL + Constant.pathOfCheckMarketCode)
                .subscribe(onNext: { result in
                    switch result {
                    case let.success(data):
                        self.handleSuccess(data: data, observer: observer)
                    case let .failure(error):
                        observer.onError(error)
                    }
                })
            return Disposables.create { disposable.dispose() }
        }
    }
