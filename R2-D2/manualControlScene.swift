//
//  manualControlScene.swift
//  R2-D2
//
//  Created by Adam Castles on 12/1/19.
//  Copyright © 2019 Adam Castles. All rights reserved.
//

import SpriteKit
import CocoaMQTT

class manualControlScene: SKScene {
    
    var buttonConnect: SKNode! = nil
    var buttonDisconnect: SKNode! = nil
    let client = CocoaMQTT(clientID: "iPhone", host: "192.168.1.13", port: 1883)
       
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
        createButtonConnect()
        createButtonDisconnect()
        setupJoystick()
    }
    
    func setupNodes() {
      self.backgroundColor = SKColor.blue
      anchorPoint = CGPoint(x: 0.5, y: 0.5)
    }
    
    func setupJoystick() {
//        velocity: -50 to 50,
        addChild(joystick)
        joystick.trackingHandler = {[unowned self] data in
            self.client.publish("rpi/manualControl", withString: "velX = " + String(format: "%.2f", data.velocity.x) + " velY = " + String(format: "%.2f", data.velocity.y) + " ang = " + String(format: "%.2f", data.angular))
        }
        joystick.stopHandler = {[unowned self] in
            self.client.publish("rpi/manualControl", withString: "velX = 0 velY = 0 ang = 0")
        }
    }
    
    func createButtonConnect() {
        buttonConnect = SKSpriteNode(color: SKColor.red, size: CGSize(width: 100, height: 44))
        buttonConnect.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        addChild(buttonConnect)
    }
    
    func createButtonDisconnect() {
        buttonDisconnect = SKSpriteNode(color: SKColor.black, size: CGSize(width: 100, height: 44))
        buttonDisconnect.position = CGPoint(x: self.frame.midX-100, y: self.frame.midY-100)
        addChild(buttonDisconnect)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)

            if buttonConnect.contains(location) {
                client.connect()
            }
            else if buttonDisconnect.contains(location) {
                client.disconnect()
            }
    }
}
}
