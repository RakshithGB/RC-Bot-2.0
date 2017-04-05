# RC Bot 2.0
## Overview
A remote control car using Raspberry Pi to host the server was designed and an iOS app which serves as the remote was written to control it. The app connects to the pi, the pi communicates with arduino over serial to control car.

## Components Used
1. Arduino Uno
2. Raspberry Pi 3
3. iOS Device (Running iOS 7.0+)
4. L298n Motor Driver
5. 12V Li-Po
6. 12V DC Motors
7. 5V Regulator
8. 5V Servo
9. USB Camera
10. Chassis, Wheels and Turning Mechanism

## Installation
1. Set up USB camera on Raspberry Pi as IP Camera using this [tutorial](https://github.com/jacksonliam/mjpg-streamer) .
2. Set up Raspberry Pi as a WiFi hotspot using this [tutorial](https://medium.com/@edoardo849/turn-a-raspberrypi-3-into-a-wifi-router-hotspot-41b03500080e) .

## Usage
### Raspberry Pi
1. Start the iphoneserver.py script in Raspberry Pi:
```sh
sudo nice -10 python iphoneserver
```
2. End the script when needed using: `ctrl-c`

### iOS
1. Sideload the iOS app using xcode onto an iOS device.
2. Once the app is loaded onto the device, it usually connects to the server instantly when its opened. If it doesn't, double tap anywhere on the screen to reconnect.
3. Swipe down with two fingers in the center region of the screen to initiate camera stream.
4. Swipe up with two fingers in the center region of the screen to cancel stream.

## References
1. [IP Camera Library](https://github.com/alchimya/iOS-IPCamViewer)
2. [iPhone Server Tutorial](https://www.raywenderlich.com/3932/networking-tutorial-for-ios-how-to-create-a-socket-based-iphone-app-and-server)
3. [Joystick Interface Tutorial](https://www.cocoacontrols.com/controls/jscontroller)
