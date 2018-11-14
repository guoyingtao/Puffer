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
    public enum RotationLimitType {
        case noLimit
        case limit(degree: Int)
    }
    
    public enum DegreeShowLimitType {
        case noLimit
        case limit(degree: Int)
    }
    
    public struct Config {
        public init() {}
        
        public var margin: Double = 10
        public var interactable = false
        public var rotationLimit: RotationLimitType = .noLimit
        public var degreeShowLimit: DegreeShowLimitType = .noLimit
        public var numberShowSpan = 1
        
        public var backgroundColor: UIColor = .black
        public var bigScaleColor: UIColor = .lightGray
        public var smallScaleColor: UIColor = .lightGray
        public var indicatorColor: UIColor = .lightGray
        public var numberColor: UIColor = .lightGray
        public var centerAxisColor: UIColor = .lightGray
    }
}
