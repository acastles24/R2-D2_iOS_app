# R2-D2 Raspberry Pi iOS Application 

*iOS app used to connect/disconnect to R2-D2 robot's Raspberry Pi via MQTT connection and for manual control via on-screen joystick.*

[Link to R2-D2 Raspberry Pi](https://github.com/acastles24/R2D2_raspberry_pi "Link to R2-D2 Raspberry Pi")

## Technologies
* Swift
* MQTT

App Launch Screen

![Launch Screen](/Images/launch_screen.png?raw=true "Main Screen") ![Main Screen](/Images/main_screen_small.png?raw=true "Main Screen")

## Code

### Establishes and Terminates IP Connection to Raspberry Pi
The user can connect and disconnect to the Raspberry Pi via MQTT protocol. The button and joystick visualization changes depending on connection state.

```swift
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
```
