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
    var buttonConnect: GeneralButtonClass! = nil
    var buttonConnectLabel: SKLabelNode! = nil
    var buttonDisconnect: GeneralButtonClass! = nil
    var buttonDisconnectLabel: SKLabelNode! = nil
    var buttonManualDrive: GeneralButtonClass! = nil
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
    
    class GeneralButtonClass:SKSpriteNode{
        var activeColorInit:SKColor?
        var highlightColorInit:SKColor?
        convenience init(activeColor: SKColor, position: CGPoint){
            self.init(texture: nil, color: SKColor.darkGray, size: CGSize(width: 100, height: 44))
            self.position = position
            activeColorInit = activeColor
            highlightColorInit = activeColor.lighterColor
        }
        
        override init(texture: SKTexture!, color: SKColor, size: CGSize){
            super.init(texture: texture, color: color, size: size)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        var activeState: Int? {
            willSet(newValue){
                if newValue == 2{
                    self.color = activeColorInit!
                }
                else if newValue == 1{
                    self.color = highlightColorInit!
                }
                else{
                    self.color = SKColor.darkGray
                }
            }
        }
    }
        
    class DriveMethodButtonClass:SKSpriteNode{
        var activeColorInit:SKColor?
        var highlightColorInit:SKColor?
        var mqttTopic:String?
        var mqttMessage:String?
        var clientFound:CocoaMQTT?
        convenience init(activeColor: SKColor, position: CGPoint, client: CocoaMQTT, topic: String, message: String){
            self.init(texture: nil, color: SKColor.darkGray, size: CGSize(width: 100, height: 44))
            self.position = position
            activeColorInit = activeColor
            highlightColorInit = activeColor.lighterColor
            mqttTopic = topic
            mqttMessage = message
            clientFound = client
        }
        
        override init(texture: SKTexture!, color: SKColor, size: CGSize){
            super.init(texture: texture, color: color, size: size)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        var activeState: Int? {
            willSet(newValue){
                if newValue == 2{
                    self.color = activeColorInit!
                }
                else if newValue == 1{
                    self.color = highlightColorInit!
                }
                else{
                    self.color = SKColor.darkGray
                }
            }
        }
    }
    
    
    class ButtonLabel:SKLabelNode{
        convenience init (text: String!, fontSize:CGFloat!, position:CGPoint!, fontColor:SKColor!, fontNamed:String!){
            self.init(fontNamed: fontNamed)
            self.text = text
            self.fontSize = fontSize
            self.position = position
            self.fontColor = fontColor
        }
    }
    
    func createButtonConnect() {
        buttonConnect = GeneralButtonClass(activeColor: SKColor.green, position: CGPoint(x: self.frame.midX, y: self.frame.midY))
        buttonConnect.activeState = 1
        buttonConnectLabel = ButtonLabel(text: "Connect", fontSize: 30, position: CGPoint(x: buttonConnect.frame.midX, y: buttonConnect.frame.midY), fontColor: SKColor.black, fontNamed: "Chalkduster")
        addChild(buttonConnect)
        addChild(buttonConnectLabel)
    }
    
    func createButtonDisconnect() {
        buttonDisconnect = GeneralButtonClass(activeColor: SKColor.red, position: CGPoint(x: self.frame.midX-100, y: self.frame.midY-100))
        buttonDisconnectLabel = ButtonLabel(text: "Disconnect", fontSize: 30, position: CGPoint(x: buttonDisconnect.frame.midX, y: buttonDisconnect.frame.midY), fontColor: SKColor.black, fontNamed: "Chalkduster")
        addChild(buttonDisconnect)
        addChild(buttonDisconnectLabel)
    }
    
    func createButtonManualDrive() {
        buttonManualDrive = GeneralButtonClass(activeColor: SKColor.orange, position: CGPoint(x: self.frame.midX+100, y: self.frame.midY+100))
        buttonManualDriveLabel = ButtonLabel(text: "Manual Drive", fontSize: 30, position: CGPoint(x: buttonManualDrive.frame.midX, y: buttonManualDrive.frame.midY), fontColor: SKColor.black, fontNamed: "Chalkduster")
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
//                todo: wait?
                connection.client.connect()
                connection.connected_state = true
                buttonConnect.activeState = 0
                buttonDisconnect.activeState = 2
                buttonManualDrive.activeState = 1
            }
            else if buttonDisconnect.contains(location) && connection.connected_state{
                connection.client.disconnect()
                connection.connected_state = false
                buttonConnect.activeState = 2
                buttonDisconnect.activeState = 0
                buttonManualDrive.activeState = 0
                current_drive_method = "None"
            }
            
            else if buttonManualDrive.contains(location){
                if current_drive_method == "None"{
                    current_drive_method = "Manual"
                    buttonManualDrive.activeState = 2
                }
                else if current_drive_method == "Manual"{
                    current_drive_method = "None"
                    buttonManualDrive.activeState = 1
                }
            }
    }
}
}
