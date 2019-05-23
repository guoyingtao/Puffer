//
//  CGAngle.swift
//  Puffer
//
//  Created by Echo on 5/22/19.
//  Copyright © 2019 Echo. All rights reserved.
//

import UIKit

public class CGAngle: NSObject {
    public var radians: CGFloat = 0.0
    
    @inlinable init(radians: CGFloat) {
        self.radians = radians
    }
    
    @inlinable init(degrees: CGFloat) {
        radians = degrees / 180.0 * CGFloat.pi
    }
    
    @inlinable var degrees: CGFloat {
        get {
            return radians / CGFloat.pi * 180.0
        }
        set {
            radians = newValue / 180.0 * CGFloat.pi
        }
    }

    override public var description: String {
        return String(format: "%0.2f°", degrees)
    }
}


