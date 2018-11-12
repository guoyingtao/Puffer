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
}
