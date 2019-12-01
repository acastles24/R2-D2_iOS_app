//
//  manualControlScene.swift
//  R2-D2
//
//  Created by Adam Castles on 12/1/19.
//  Copyright © 2019 Adam Castles. All rights reserved.
//

import SpriteKit

class manualControlScene: SKScene {
    
    lazy var joystick: TLAnalogJoystick = {
        let jstick = TLAnalogJoystick(withDiameter: 100)
        jstick.position = CGPoint(x: UIScreen.main.bounds.size.width * -0.5 + jstick.radius + 45, y: UIScreen.main.bounds.size.height * -0.5 + jstick.radius + 45)
        return jstick
    }()
    
    func setup(){
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        setupJoystick()
    }
    
    override func didMove(to view: SKView) {
        <#code#>
    }
    
    func setupJoystick(){
        addChild(joystick)
        
    }
}
