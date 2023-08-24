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
    
