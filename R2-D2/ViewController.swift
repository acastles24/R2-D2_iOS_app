//
//  ViewController.swift
//  R2-D2
//
//  Created by Adam Castles on 11/25/19.
//  Copyright © 2019 Adam Castles. All rights reserved.
//

import UIKit
import SpriteKit
import CocoaMQTT

class ViewController: UIViewController {
    let mqttClient = CocoaMQTT(clientID: "Adam's iPhone", host: "192.168.1.13", port: 1883)
    
    var skView = SKView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    fileprivate func setViews(){
        view.addSubview(skView)
        skView.frame = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width)
        let scene = manualControlScene(size: CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width))
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
    }

}

