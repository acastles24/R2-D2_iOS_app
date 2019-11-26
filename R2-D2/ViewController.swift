//
//  ViewController.swift
//  R2-D2
//
//  Created by Adam Castles on 11/25/19.
//  Copyright © 2019 Adam Castles. All rights reserved.
//

import UIKit
import CocoaMQTT

class ViewController: UIViewController {
    
    let mqttClient = CocoaMQTT(clientID: "Adam's iPhone", host: "192.168.1.13", port: 1883)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func mqtt_connect(_ sender: UIButton) {
        mqttClient.connect()
    }
    @IBAction func mqtt_disconnect(_ sender: UIButton) {
        mqttClient.disconnect()
    }
    
    @IBAction func drive_forward(_ sender: UIButton) {
        if sender.isSelected{
            mqttClient.publish("rpi/manual_fwd", withString: "fwd")
        }
        else{
            mqttClient.publish("rpi/manual_fwd", withString: "not_fwd")
        }
    }
    @IBAction func drive_backwards(_ sender: UIButton) {
        if sender.isSelected{
            mqttClient.publish("rpi/manual_back", withString: "back")
        }
        else{
            mqttClient.publish("rpi/manual_back", withString: "not_back")
        }
    }
    
    @IBAction func turn_left_right(_ sender: UISlider) {
        //todo: snap back to zero when untouched
        mqttClient.publish("rpi/manual_back", withString: String(sender.value))
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
