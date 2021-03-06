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
    var buttonConnect: GeneralButton! = nil
    var buttonConnectLabel: SKLabelNode! = nil
    var buttonDisconnect: GeneralButton! = nil
    var buttonDisconnectLabel: SKLabelNode! = nil
    var buttonManualDrive: GeneralButton! = nil
    var buttonManualDriveLabel: SKLabelNode! = nil
    var current_drive_method: String = "None"
    let joystick_rad: CGFloat = ScreenSize.width * 0.2
    struct mqttTopics{
        let manualDriveTopic = "rpi/manualControl"
        let driveModeTopic = "rpi/driveMode"
    }
    
    let topics = mqttTopics()
    
    var connection = CocoaMQTT(clientID: "Adam's iPhone", host: "192.168.1.13", port: 1883)
    
       
    enum NodesZPosition: CGFloat {
    case joystick
    }
        
    lazy var joystick: AnalogJoystick = {
        let js = AnalogJoystick(diameter: CGFloat(joystick_rad * 2), colors: (UIColor.darkGray, UIColor.gray))
        js.position = CGPoint(x: 0, y: ScreenSize.height * -0.45 + js.radius + 45)
      js.zPosition = NodesZPosition.joystick.rawValue
      return js
    }()
    
    override func didMove(to view: SKView) {
        setupNodes()
        createButtonConnect()
        createButtonDisconnect()
        createButtonManualDrive()
        setupJoystick(joystick: joystick)
        addChild(joystick)
    }
    
    func setupNodes() {
      self.backgroundColor = SKColor.lightGray
      anchorPoint = CGPoint(x: 0.5, y: 0.5)
    }
    
    func setupJoystick(joystick: AnalogJoystick) {
        joystick.trackingHandler = {[unowned self] data in
            self.connection.publish(self.topics.manualDriveTopic, withString: "velX = " +  String(format: "%.2f",self.normalizeJoystickVelocity(vel: data.velocity.x, mag: self.joystick_rad)) + " velY = " + String(format: "%.2f", self.normalizeJoystickVelocity(vel: data.velocity.y, mag: self.joystick_rad)) + " ang = " + String(format: "%.2f", data.angular))
        }
        joystick.stopHandler = {[unowned self] data in
            self.connection.publish(self.topics.manualDriveTopic, withString: "velX = " + String(format: "%.2f", self.normalizeJoystickVelocity(vel: data.velocity.x, mag: self.joystick_rad)) + " velY = " + String(format: "%.2f", self.normalizeJoystickVelocity(vel: data.velocity.y, mag: self.joystick_rad)) + " ang = " + String(format: "%.2f", data.angular))
        }
    }

    class GeneralButton:SKShapeNode{
        var activeColorInit:SKColor?
        var highlightColorInit:SKColor?
        convenience init(activeColor: SKColor, position: CGPoint){
            self.init(rectOf: CGSize(width: 150, height: 60), cornerRadius: 5)
            self.position = position
            self.lineWidth = 4
            self.strokeColor = UIColor.black
            self.fillColor = UIColor.gray
            activeColorInit = activeColor
            highlightColorInit = activeColor.lighterColor
        }
        
        func becomeActive(){
            
        }
        
        func becomeHighlighted(){
        }
        
        var activeState: Int? {
            willSet(newValue){
                if newValue == 2{
                    self.fillColor = activeColorInit!
                    becomeActive()
//                    !
                }
                else if newValue == 1{
                    self.fillColor = highlightColorInit!
                    becomeHighlighted()
//                    !
                }
                else{
                    self.fillColor = SKColor.darkGray
                }
            }
        }
    }
    
    class DriveButton:GeneralButton{
        var mqttTopic:String?
        var mqttMessage:String?
        var clientFound:CocoaMQTT?
        convenience init(activeColor: SKColor, position: CGPoint, client: CocoaMQTT, topic: String, message: String){
            self.init(activeColor: activeColor, position: position)
            mqttTopic = topic
            mqttMessage = message
            clientFound = client
        }
        
        override func becomeActive() {
            clientFound!.publish(mqttTopic!, withString: mqttMessage!)
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
        buttonConnect = GeneralButton(activeColor: SKColor.green, position: CGPoint(x: self.frame.midX+100, y: self.frame.midY+200))
        buttonConnect.activeState = 1
        buttonConnectLabel = ButtonLabel(text: "Connect", fontSize: 20, position: CGPoint(x: buttonConnect.frame.midX, y: buttonConnect.frame.midY), fontColor: SKColor.black, fontNamed: "Copperplate")
        addChild(buttonConnect)
        addChild(buttonConnectLabel)
    }
    
    func createButtonDisconnect() {
        buttonDisconnect = GeneralButton(activeColor: SKColor.red, position: CGPoint(x: self.frame.midX-100, y: self.frame.midY+200))
        buttonDisconnectLabel = ButtonLabel(text: "Disconnect", fontSize: 20, position: CGPoint(x: buttonDisconnect.frame.midX, y: buttonDisconnect.frame.midY), fontColor: SKColor.black, fontNamed: "Copperplate")
        addChild(buttonDisconnect)
        addChild(buttonDisconnectLabel)
    }
    
    func createButtonManualDrive() {
        buttonManualDrive = DriveButton(activeColor: SKColor.init(red: 0, green: 106/255, blue: 255/255, alpha: 1), position: CGPoint(x: self.frame.midX, y: self.frame.midY+50), client: connection, topic: topics.driveModeTopic, message: current_drive_method)
        buttonManualDriveLabel = ButtonLabel(text: "Manual Drive", fontSize: 20, position: CGPoint(x: buttonManualDrive.frame.midX, y: buttonManualDrive.frame.midY), fontColor: SKColor.black, fontNamed: "Copperplate")
        addChild(buttonManualDrive)
        addChild(buttonManualDriveLabel)
    }
    
    func normalizeJoystickVelocity(vel: CGFloat, mag: CGFloat) -> CGFloat{
        return vel/mag
    }
    
    func deactivateJoystick(){
        joystick.substrate.color = SKColor.darkGray
        joystick.stick.color = SKColor.gray
    }
    
    func activateJoystick(){
        joystick.substrate.color = SKColor.white
        joystick.stick.color = SKColor.init(red: 0, green: 106/255, blue: 255/255, alpha: 1)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)

            if buttonConnect.contains(location) && connection.connState == .initial {
                connection.connect()
                if connection.connState == .connected ||  connection.connState == .connecting{
                    buttonConnect.activeState = 2
                    buttonDisconnect.activeState = 1
                    buttonManualDrive.activeState = 1
                }
                    
            }
            else if buttonDisconnect.contains(location) && (connection.connState == .connected ||  connection.connState == .connecting){
                connection.disconnect()
                buttonConnect.activeState = 1
                buttonDisconnect.activeState = 0
                buttonManualDrive.activeState = 0
                current_drive_method = "None"
                deactivateJoystick()
            }
            
            else if buttonManualDrive.contains(location){
                if current_drive_method == "None" && (connection.connState == .connected ||  connection.connState == .connecting){
                    current_drive_method = "Manual"
                    buttonManualDrive.activeState = 2
                    activateJoystick()
                    
                }
                else if current_drive_method == "Manual"{
                    current_drive_method = "None"
                    buttonManualDrive.activeState = 1
                    deactivateJoystick()
                }
            }
    }
}
}
