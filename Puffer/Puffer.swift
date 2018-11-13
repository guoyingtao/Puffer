//
//  Puffer.swift
//  Puffer
//
//  Created by Echo on 11/12/18.
//  Copyright © 2018 Echo. All rights reserved.
//

import Foundation

public struct Puffer {
    public static func createDialPlate() -> UIView {
        return RotationDial(frame: CGRect.zero)
    }
    
    public static func createDialPlate(withRotationCenter rotationCenter: CGPoint) -> UIView {
        let dial = RotationDial(frame: CGRect.zero)
        dial.rotationCenter = rotationCenter
        return dial
    }
}

extension Puffer {
    struct Config {
        var interactable = false
        var maxRotationAngle: Double = 0 // 0 - no limit
        var maxShowAngle: Double = 180 // 180 - show allpod trunk delete Mantis 0.17
    }
}
