//
//  ViewController.swift
//  R2-D2
//
//  Created by Adam Castles on 11/25/19.
//  Copyright © 2019 Adam Castles. All rights reserved.
//

import SpriteKit

class ManualViewController: UIViewController {
  
  lazy var skView: SKView = {
    let view = SKView()
    //        view.translatesAutoresizingMaskIntoConstraints = false
    view.isMultipleTouchEnabled = true
    return view
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    setupViews()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  fileprivate func setupViews() {
    view.addSubview(skView)
    
    skView.frame = CGRect(x: 0.0, y: 0.0, width: ScreenSize.width, height: ScreenSize.height)
    
    let scene = manualControlScene(size: CGSize(width: ScreenSize.width, height: ScreenSize.height))
    scene.scaleMode = .aspectFill
    skView.presentScene(scene)
    skView.ignoresSiblingOrder = true
    //    skView.showsFPS = true
    //    skView.showsNodeCount = true
    //    skView.showsPhysics = true
  }
  
}

