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
