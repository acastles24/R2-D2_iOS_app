//
//  Extensions.swift
//  JoystickTank
//
//  Created by Alex Nagy on 05/07/2018.
//  Copyright © 2018 Alex Nagy. All rights reserved.
//

import SpriteKit

struct ScreenSize {
  static let width        = UIScreen.main.bounds.size.width
  static let height       = UIScreen.main.bounds.size.height
  static let maxLength    = max(ScreenSize.width, ScreenSize.height)
  static let minLength    = min(ScreenSize.width, ScreenSize.height)
  static let size         = CGSize(width: ScreenSize.width, height: ScreenSize.height)
}

struct DeviceType {
  static let isiPhone4OrLess = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxLength < 568.0
  static let isiPhone5 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxLength == 568.0
  static let isiPhone6 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxLength == 667.0
  static let isiPhone6Plus = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxLength == 736.0
  static let isiPhoneX = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxLength == 812.0
  static let isiPad = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.maxLength == 1024.0
  static let isiPadPro = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.maxLength == 1366.0
}

public extension SKSpriteNode {
  
  func scaleTo(screenWidthPercentage: CGFloat) {
    let aspectRatio = self.size.height / self.size.width
    self.size.width = ScreenSize.width * screenWidthPercentage
    self.size.height = self.size.width * aspectRatio
  }
  
}


extension SKColor {
//    Credit to Aviel Gross:
//    https://stackoverflow.com/questions/11598043/get-slightly-lighter-and-darker-color-from-uicolor
    var lighterColor: SKColor {
        return lighterColor(removeSaturation: 0.75, resultAlpha: -1)
    }

    func lighterColor(removeSaturation val: CGFloat, resultAlpha alpha: CGFloat) -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0
        var b: CGFloat = 0, a: CGFloat = 0

        guard getHue(&h, saturation: &s, brightness: &b, alpha: &a)
            else {return self}

        return SKColor(hue: h,
                       saturation: max(s - val, 0.0),
                       brightness: b,
                       alpha: alpha == -1 ? a : alpha)
    }
}
