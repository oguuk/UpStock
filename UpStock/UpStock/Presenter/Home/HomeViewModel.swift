//
//  HomeViewModel.swift
//  UpStock
//
//  Created by 오국원 on 2023/07/27.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import ActivityKit
import CoinLiveActivityExtension

final class HomeViewModel {
    
    struct Input {
        let keyboard: Observable<String>
    }
    
    struct Output {
        let stocks: Driver<[TickerResponse]> //Observable<[SectionModel<String, WebsocketTickerResponse>]>
    }
    
    private let upbit: UpbitAPIManager = UpbitAPIManager()
    private var sockets: [String : UpbitWebSocketClient] = [:]
    private let soketsSubject: BehaviorSubject<[String : WebsocketTickerResponse]> = BehaviorSubject<[String : WebsocketTickerResponse]>(value: [:])
    private let searchResultsSubject: BehaviorSubject<[TickerResponse]> = BehaviorSubject<[TickerResponse]>(value: [])
    private var lastTradePrice: [String : Double] = [:]
    private let disposeBag: DisposeBag = DisposeBag()
    let starActionSubject = PublishSubject<IndexPath>()
    var activities: [String : Activity<CoinLiveActivityAttributes>] = [:]
    
    init() {
        configureSocket()
    }
    
    func transform(input: Input) -> Output {
        let stocksObservable: Observable<[TickerResponse]> = input.keyboard
            .flatMapLatest { [weak self] text -> Observable<[TickerResponse]> in
                if text.isEmpty {
                    return self?.soketsSubject
                        .map { stocksDict -> [TickerResponse] in
                            return stocksDict.values.sorted { $0.code < $1.code }
                            .compactMap { $0.toTickerResponse() }
                        } ?? .empty()
                } else {
                    self?.searchStocks(coinName: text)
                    return self?.searchResultsSubject ?? .empty()
                }
            }

        return Output(stocks: stocksObservable.asDriver(onErrorJustReturn: []))
    }
    
    func configureSocket() {
        CoreDataManager.default.fetch(type: BOOKMARK.self)?.forEach {
            fetchSocket(coin: $0.market!)
        }
    }
    
    func bookmark(market: String) {
        if !isBookmark(market: market) {
            if CoreDataManager.default.count(forEntityName: "BOOKMARK") > 5 {
                print("5개를 초과합니다.")
                return
            }
            guard let datas = CoreDataManager.default.fetch(type: KRW.self, name: market),
                  let data = datas.first else { return }
            let marketValue = Market(market: data.market!, koreanName: data.koreanName!, englishName: data.englishName!)
            CoreDataManager.default.save(forEntityName: "BOOKMARK", value: marketValue)
            fetchSocket(coin: market)
        }
    }
    
    func unBookmark(market: String) {
        CoreDataManager.default.delete(type: BOOKMARK.self, name: market)
        sockets[market] = nil

        if var currentStocks = try? soketsSubject.value() {
            currentStocks[market] = nil
            soketsSubject.onNext(currentStocks)
        }

        sockets.keys.forEach {
            fetchSocket(coin: $0)
        }
    }
    
    private func fetchSocket(coin name: String) {
        
        CoreDataManager.default.fetch(type: KRW.self, name: name)?
            .forEach { coin in
                let request = "[{\"ticket\":\"Upstock\"},{\"type\":\"ticker\",\"codes\":[\"\(coin.market!)\"]}]"
                let service = UpbitWebSocketClient(request: request)
                sockets[coin.market!] = service
                sockets[coin.market!]?.dataSubject
                    .subscribe(onNext: { [weak self] data in
                        do {
                            guard let ticker = try? JSONDecoder().decode(WebsocketTickerResponse.self, from: data) else { return }
                            if var currentStocks = try? self?.soketsSubject.value() {
                                currentStocks[ticker.code] = ticker
                                Task { [weak self] in
                                    await self?.startLiveActivity(ticker: ticker)
                                }
                                
                                self?.soketsSubject.onNext(currentStocks)
                            } else {
                                self?.soketsSubject.onNext([ticker.code: ticker])
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    })
                    .disposed(by: disposeBag)
                sockets[coin.market!]?.start()
        }
    }
}
