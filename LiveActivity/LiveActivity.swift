//
//  LiveActivity.swift
//  LiveActivity
//
//  Created by 吴丹 on 2022/7/28.
//

import WidgetKit
import SwiftUI
import ActivityKit

struct PizzaDeliveryAttributes: ActivityAttributes {
    public typealias PizzaDeliveryStatus = ContentState

    public struct ContentState: Codable, Hashable {
        var driverName: String
        var estimatedDeliveryTime: Date
    }

    var numberOfPizzas: Int
    var totalAmount: String
}

@available(iOSApplicationExtension 16.1, *)
struct PizzaDeliveryActivityWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration<PizzaDeliveryAttributes> { context in
            VStack {
                Text(context.state.estimatedDeliveryTime, style: .timer)
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(.red)
        } dynamicIsland: { context in
            VStack {
                 Text(context.state.estimatedDeliveryTime, style: .timer)
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(.red) as! DynamicIsland
        }
    }
}

@available(iOSApplicationExtension 16.1, *)
@main
struct LiveActivity: Widget {
    let kind: String = "LiveActivity"
    
    var body: some WidgetConfiguration {
        ActivityConfiguration<PizzaDeliveryAttributes>{ context in
            VStack {
                Spacer().frame(height: 5)
                HStack {
                    Spacer().frame(width: 15)
                    Text("这是APP名称").foregroundColor(.blue).fontWeight(.medium).font(.system(size: 16))
                    Spacer()
                }
                HStack {
                    Spacer().frame(width: 15)
                    Text("停车时间：17:08:38")
                    Spacer()
                    Text("3小时30分钟 - \(context.state.driverName)元").foregroundColor(.red).fontWeight(.medium)
                    Spacer().frame(width: 15)
                }
                ZStack {
                    Divider()
                        .foregroundColor(.gray)
                    Image("icon_car")
                }
                Spacer().frame(height: 5)
            }
            .activitySystemActionForegroundColor(Color.cyan)
            .activitySystemActionForegroundColor(.red)
        } dynamicIsland: { context in
            DynamicIsland { // 长按
                DynamicIslandExpandedRegion(.leading) {
                    Label("长按时显示左边内容", systemImage: "bag")
                        .foregroundColor(.orange)
                        .font(.caption2)
                }
                                
                DynamicIslandExpandedRegion(.trailing) {
                    Label("长按时显示右边内容", systemImage: "bag")
                        .foregroundColor(.green)
                        .font(.caption2)
                }
                
                DynamicIslandExpandedRegion(.center) {
                    Text("长按时显示中间内容")
                        .lineLimit(1)
                        .font(.caption)
                        .foregroundColor(.yellow)

                }
                
                DynamicIslandExpandedRegion(.bottom) {
                    Label("长按时显示底部内容", systemImage: "bag")
                        .foregroundColor(.red)
                        .font(.caption2)
                }
            } compactLeading: { // 只有一个应用时显示左边
                Label {
                    Text("这是左边文字和图标")
                } icon: {
                    Image(systemName: "bag")
                        .foregroundColor(.green)
                }
                .font(.caption2)
                                   
            } compactTrailing: { // 只有一个应用时显示右边
                Label {
                    Text("这右边边文字和图标")
                } icon: {
                    Image(systemName: "bag")
                        .foregroundColor(.yellow)
                }
                .font(.caption2)
            } minimal: { // 最小化的时候
                HStack {
                    Image(systemName: "bag")
                        .foregroundColor(.orange).frame(width: 10)
                    Image(systemName: "pencil.and.outline")
                        .foregroundColor(.red).frame(width: 10)
                    Image(systemName: "folder.circle.fill")
                        .foregroundColor(.green).frame(width: 10)
                }
            }
        }
    }
}
