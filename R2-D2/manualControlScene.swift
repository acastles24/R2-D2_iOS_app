//
//  manualControlScene.swift
//  R2-D2
//
//  Created by Adam Castles on 12/1/19.
//  Copyright © 2019 Adam Castles. All rights reserved.
//

import SpriteKit

class manualControlScene: SKScene {
    
  enum NodesZPosition: CGFloat {
  case background, hero, joystick
  }
    
    lazy var analogJoystick: TLAnalogJoystick = {
      let js = TLAnalogJoystick(withDiameter: 100)
      js.position = CGPoint(x: ScreenSize.width * -0.5 + js.radius + 45, y: ScreenSize.height * -0.5 + js.radius + 45)
      js.zPosition = NodesZPosition.joystick.rawValue
      return js
    }()
    
    override func didMove(to view: SKView) {
      setupNodes()
      setupJoystick()
    }
    
    func setupNodes() {
      anchorPoint = CGPoint(x: 0.5, y: 0.5)
    }
    
    func setupJoystick() {
          addChild(analogJoystick)
    }
}
