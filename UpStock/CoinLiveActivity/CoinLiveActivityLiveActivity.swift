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

struct CoinLiveActivityLiveActivity: Widget {
        
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: CoinLiveActivityAttributes.self) { context in
            
            let color = context.state.state > -1 ? (context.state.state == 0 ? Color.gray : Color.green) : Color.pink
            
            // Lock screen/banner UI goes here
            VStack {
                HStack {
                    
                    HStack {
                        Image(context.state.imageName)
                            .resizable()
                            .frame(width: 10, height: 30)
                            .scaledToFit()

                        Text(context.attributes.coinName)
                            .font(.callout)
                            .foregroundColor(Color.white)
                    }
                    .padding(.leading, 12)
                    
                    HStack {
                        VStack {
                            Spacer()
                            Text(context.state.price)
                                .fontWeight(.semibold)
                                .foregroundColor(color)
                            Spacer()
                        }
                    }
                    .padding(.leading, 8)
                    .padding(.trailing, 8)
                    
                    HStack {
                        VStack {
                            Spacer()
                            Text(context.state.priceFluctuation)
                                .font(.caption2)
                                .foregroundColor(color)
                            Text(context.state.tradeVolume)
                                .font(.caption2)
                                .foregroundColor(.white)
                            Spacer()
                        }
                        Text(context.state.fluctuationRate)
                            .fontWeight(.bold)
                            .padding(.trailing, 12)
                            .foregroundColor(color)
                    }
                }
            }
            .activityBackgroundTint(Color.black)
            .activitySystemActionForegroundColor(Color.red)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T")
            } minimal: {
                Text("Min")
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
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
