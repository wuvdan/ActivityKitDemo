//
//  ViewController.swift
//  Test-Swift
//
//  Created by 吴丹 on 2022/7/28.
//

import UIKit
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

class ViewController: UIViewController {
    var activity: Activity<PizzaDeliveryAttributes>?
    var timer: Timer?
    
    var count: Double = 1
    
    var timeCount: Int = 1
    
    lazy var startButton: UIButton = {
        let b = UIButton()
        b.setTitle("点击开始运行", for: .normal)
        b.addTarget(self, action: #selector(didStartAction), for: .touchUpInside)
        return b
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .gray
        
        view.addSubview(startButton)
        startButton.bounds = CGRect(x: 0, y: 0, width: 150, height: 50)
        startButton.center = view.center
        
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { timer in
            Task {
                self.count = self.count + 0.05
                
                let text = String(format: "%.2f", self.count)
                
                if let activity = self.activity {
                    await activity.update(using: Activity<PizzaDeliveryAttributes>.ContentState(driverName: text, estimatedDeliveryTime: Date()))
                }
                
                self.timeCount = self.timeCount + 1
            }
        })
    }
    
    @objc func didStartAction() {
        if activity == nil {
            activity = try! Activity<PizzaDeliveryAttributes>.request(attributes: PizzaDeliveryAttributes(numberOfPizzas: timeCount, totalAmount: "1222"), contentState: .init(driverName: "1", estimatedDeliveryTime: Date(timeIntervalSince1970: 0)))
        } else {
            Task {
                if let activity = activity {
                    await activity.update(using: Activity<PizzaDeliveryAttributes>.ContentState(driverName: "\(count)", estimatedDeliveryTime: Date()))
                }
            }
        }
    }
}

