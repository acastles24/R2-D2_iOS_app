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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    let scene = JoystickScene(size: self.view.bounds.size)
    scene.backgroundColor = .white
    
    if; let skView = self.view as? SKView {
            skView.showsFPS = true
            skView.showsNodeCount = true
            skView.ignoresSiblingOrder = true
            skView.presentScene(scene)
    }
    
    /*
     {
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

