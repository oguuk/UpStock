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
