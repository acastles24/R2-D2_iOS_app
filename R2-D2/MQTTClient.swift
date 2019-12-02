//
//  MQTTClient.swift
//  R2-D2
//
//  Created by Adam Castles on 12/1/19.
//  Copyright © 2019 Adam Castles. All rights reserved.
//
import CocoaMQTT

class MQTTClient {
    let client: CocoaMQTT
    
    init(clientName: String, hostName: String, portNum: Int) {
        self.client = CocoaMQTT(clientID: clientName, host: hostName, port: UInt16(portNum))
        client.connect()
    }
    
    func publish(topic: String, message: String){
        self.client.publish(topic, withString: message)
    }
        
}
