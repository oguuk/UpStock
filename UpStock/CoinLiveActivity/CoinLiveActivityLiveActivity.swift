//
//  CoinLiveActivityLiveActivity.swift
//  CoinLiveActivity
//
//  Created by 오국원 on 2023/08/16.
//

import ActivityKit
import WidgetKit
import SwiftUI

public struct CoinLiveActivityAttributes: ActivityAttributes {
    
    public init(coinName: String) { self.coinName = coinName }
    
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        
        public init(imageName: String, price: String,
             tradeVolume: String, fluctuationRate: String,
             priceFluctuation: String, state: Int) {
            self.imageName = imageName
            self.price = price
            self.tradeVolume = tradeVolume
            self.fluctuationRate = fluctuationRate
            self.priceFluctuation = priceFluctuation
            self.state = state
        }
        
        public var imageName: String
        public var price: String
        public var tradeVolume: String
        public var fluctuationRate: String
        public var priceFluctuation: String
        public var state: Int
    }

    // Fixed non-changing properties about your activity go here!
    public var coinName: String
}
}

struct CoinLiveActivityLiveActivity_Previews: PreviewProvider {
    static let attributes = CoinLiveActivityAttributes(coinName: "비트코인")
    static let contentState = CoinLiveActivityAttributes.ContentState(
        imageName: "rise3",
        price: "38,000,000",
        tradeVolume: "123123123",
        fluctuationRate: "-1.2%",
        priceFluctuation: "-1,000,000",
        state: 1)

    static var previews: some View {
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.compact))
            .previewDisplayName("Island Compact")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.expanded))
            .previewDisplayName("Island Expanded")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.minimal))
            .previewDisplayName("Minimal")
        attributes
            .previewContext(contentState, viewKind: .content)
            .previewDisplayName("Notification")
    }
}
