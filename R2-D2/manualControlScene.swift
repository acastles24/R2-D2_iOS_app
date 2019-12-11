//
//  manualControlScene.swift
//  R2-D2//
//  Created by Adam Castles on 12/1/19.

//  Copyright © 2019 Adam Castles. All rights reserved.
//

import SpriteKit
import CocoaMQTT

class manualControlScene: SKScene {
    
//    todo: scale
    var buttonConnect: ButtonClass! = nil
    var buttonConnectLabel: SKLabelNode! = nil
    var buttonDisconnect: ButtonClass! = nil
    var buttonDisconnectLabel: SKLabelNode! = nil
    var buttonManualDrive: ButtonClass! = nil
    var buttonManualDriveLabel: SKLabelNode! = nil
    var current_drive_method: String = "None"
    let joystick_rad: CGFloat = 75
    
    struct mqttConnection {
        let client = CocoaMQTT(clientID: "Adam's iPhone", host: "192.168.1.13", port: 1883)
        var connected_state = false
    }
    
    var connection = mqttConnection()
    
       
    enum NodesZPosition: CGFloat {
    case joystick
    }
        
    lazy var joystick: AnalogJoystick = {
        let js = AnalogJoystick(diameter: CGFloat(joystick_rad * 2), colors: (UIColor.white, UIColor.blue))
        js.position = CGPoint(x: 0, y: ScreenSize.height * -0.5 + js.radius + 45)
      js.zPosition = NodesZPosition.joystick.rawValue
      return js
    }()
    
    override func didMove(to view: SKView) {
        setupNodes()
        createButtonConnect()
        createButtonDisconnect()
        createButtonManualDrive()
        setupJoystick(joystick: joystick)
    }
    
    func setupNodes() {
      self.backgroundColor = SKColor.lightGray
      anchorPoint = CGPoint(x: 0.5, y: 0.5)
    }
    
    func setupJoystick(joystick: AnalogJoystick) {
        addChild(joystick)
        joystick.trackingHandler = {[unowned self] data in
            self.connection.client.publish("rpi/manualControl", withString: "velX = " +  String(format: "%.2f",self.normalizeJoystickVelocity(vel: data.velocity.x, mag: self.joystick_rad)) + " velY = " + String(format: "%.2f", self.normalizeJoystickVelocity(vel: data.velocity.y, mag: self.joystick_rad)) + " ang = " + String(format: "%.2f", data.angular))
        }
        joystick.stopHandler = {[unowned self] data in
            self.connection.client.publish("rpi/manualControl", withString: "velX = " + String(format: "%.2f", self.normalizeJoystickVelocity(vel: data.velocity.x, mag: self.joystick_rad)) + " velY = " + String(format: "%.2f", self.normalizeJoystickVelocity(vel: data.velocity.y, mag: self.joystick_rad)) + " ang = " + String(format: "%.2f", data.angular))
        }
    }
    
    class ButtonClass:SKSpriteNode{
        var activeColorInit:SKColor
        var clientFound:CocoaMQTT
        convenience init(activeColor: SKColor, position: CGPoint, client: CocoaMQTT){
            self.init(texture: nil, color: SKColor.darkGray, size: CGSize(width: 100, height: 44))
            self.position = position
            clientFound = client
            activeColorInit = activeColor
        }
        
        override init(texture: SKTexture!, color: SKColor, size: CGSize){
            super.init(texture: texture, color: color, size: size)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func activeAction(){
            preconditionFailure("Implement activeAction method.")
        }
        
        func inactiveAction(){
            preconditionFailure("Implement inactiveAction method.")
        }
        
        var isActive: Bool? {
            willSet(newValue){
                if newValue == true{
                    self.color = activeColorInit
                }
                else{
                    self.color = SKColor.darkGray
                }
            }
        }
    }
    
    
    
    func createButtonConnect() {
        buttonConnect = ButtonClass(activeColor: SKColor.green, position: CGPoint(x: self.frame.midX, y: self.frame.midY), client: connection.client)
        buttonConnect.isActive = true
        buttonConnectLabel = SKLabelNode(text: "Connect")
        buttonConnectLabel.fontSize = 30
        buttonConnectLabel.fontColor = SKColor.black
        buttonConnectLabel.position = CGPoint(x: buttonConnect.frame.midX, y: buttonConnect.frame.midY)
        addChild(buttonConnect)
        addChild(buttonConnectLabel)
    }
    
    func createButtonDisconnect() {
        buttonDisconnect = ButtonClass(activeColor: SKColor.red, position: CGPoint(x: self.frame.midX-100, y: self.frame.midY-100), client: connection.client)
        buttonDisconnectLabel = SKLabelNode(text: "Disconnect")
        buttonDisconnectLabel.fontSize = 30
        buttonDisconnectLabel.fontColor = SKColor.black
        buttonDisconnectLabel.position = CGPoint(x: buttonDisconnect.frame.midX, y: buttonDisconnect.frame.midY)
        addChild(buttonDisconnect)
        addChild(buttonDisconnectLabel)
    }
    
    func createButtonManualDrive() {
        buttonManualDrive = ButtonClass(activeColor: SKColor.orange, position: CGPoint(x: self.frame.midX+100, y: self.frame.midY+100), client: connection.client)
        buttonManualDriveLabel = SKLabelNode(text: "Manual")
        buttonManualDriveLabel.fontSize = 30
        buttonManualDriveLabel.fontColor = SKColor.black
        buttonManualDriveLabel.position = CGPoint(x: buttonManualDrive.frame.midX, y: buttonManualDrive.frame.midY)
        addChild(buttonManualDrive)
        addChild(buttonManualDriveLabel)
    }
    
    func normalizeJoystickVelocity(vel: CGFloat, mag: CGFloat) -> CGFloat{
        return vel/mag
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)

            if buttonConnect.contains(location) && !connection.connected_state {
                connection.client.connect()
                connection.connected_state = true
                buttonConnect.isActive = false
                buttonDisconnect.isActive = true
                buttonManualDrive.isActive = true
            }
            else if buttonDisconnect.contains(location) && connection.connected_state{
                connection.client.disconnect()
                connection.connected_state = false
                buttonConnect.isActive = true
                buttonDisconnect.isActive = false
                buttonManualDrive.isActive = false
                current_drive_method = "None"
            }
            
            else if buttonManualDrive.contains(location) {
                
                current_drive_method = "Manual"
            }
    }
}
}
