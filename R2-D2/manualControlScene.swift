//
//  manualControlScene.swift
//  R2-D2
//
//  Created by Adam Castles on 12/1/19.
//  Copyright © 2019 Adam Castles. All rights reserved.
//

import SpriteKit

class manualControlScene: SKScene {
    
    func setupClient() -> CocoaMQTT {
        let client = CocoaMQTT(clientID: "iPhone", host: "192.168.1.13", port: 1883)
        client.connect()
        client.publish("rpi/manualControl", withString: "terst")
        return client
    }
    
    enum NodesZPosition: CGFloat {
    case joystick
    }
        
    lazy var joystick: AnalogJoystick = {
      let js = AnalogJoystick(diameter: 100, colors: (UIColor.red, UIColor.yellow))
      js.position = CGPoint(x: ScreenSize.width * -0.5 + js.radius + 45, y: ScreenSize.height * -0.5 + js.radius + 45)
      js.zPosition = NodesZPosition.joystick.rawValue
      return js
    }()
    
    override func didMove(to view: SKView) {
        setupNodes()
        let clientConnected = setupClient()
        setupJoystick(mqttClient: clientConnected)
    }
    
    func setupNodes() {
      self.backgroundColor = SKColor.blue
      anchorPoint = CGPoint(x: 0.5, y: 0.5)
    }
    
    func setupJoystick(mqttClient: CocoaMQTT) {
        addChild(joystick)
        joystick.trackingHandler = {data in
            mqttClient.publish("rpi/manualControl", withString: "velX = " + String(format: "%.2f", data.velocity.x) + " velY = " + String(format: "%.2f", data.velocity.y) + " ang = " + String(format: "%.2f", data.angular)
            )
        }
    }
}
