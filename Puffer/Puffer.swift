//
//  Puffer.swift
//  Puffer
//
//  Created by Echo on 11/12/18.
//  Copyright © 2018 Echo. All rights reserved.
//

import UIKit

public struct Puffer {
    public static func createDial(config: Config = Config()) -> RotationDial {
        return RotationDial(frame: CGRect.zero, config: config)
    }
}

extension Puffer {
    public enum RotationCenterType {
        case useDefault
        case custom(CGPoint)
    }

    public enum RotationLimitType {
        case noLimit
        case limit(degree: Int)
    }
    
    public enum DegreeShowLimitType {
        case noLimit
        case limit(degree: Int)
    }
    
    public enum Orientation {
        case normal
        case right
        case left
        case upsideDown
    }
    
    public enum Theme {
        case dark
        case light
    }
    
    public struct Config {
        public init() {}
        
        public var margin: Double = 10
        public var interactable = false
        public var rotationLimitType: RotationLimitType = .noLimit
        public var degreeShowLimitType: DegreeShowLimitType = .noLimit
        public var rotationCenterType: RotationCenterType = .useDefault
        public var numberShowSpan = 2
        public var orientation: Orientation = .normal
        
        public var backgroundColor: UIColor = .black
        public var bigScaleColor: UIColor = .lightGray
        public var smallScaleColor: UIColor = .lightGray
        public var indicatorColor: UIColor = .lightGray
        public var numberColor: UIColor = .lightGray
        public var centerAxisColor: UIColor = .lightGray
        
        public var theme: Theme = .dark {
            didSet {
                switch theme {
                case .dark:
                    backgroundColor = .black
                    bigScaleColor = .lightGray
                    smallScaleColor = .lightGray
                    indicatorColor = .lightGray
                    numberColor = .lightGray
                    centerAxisColor = .lightGray
                case .light:
                    backgroundColor = .white
                    bigScaleColor = .darkGray
                    smallScaleColor = .darkGray
                    indicatorColor = .darkGray
                    numberColor = .darkGray
                    centerAxisColor = .darkGray
                }
            }
        }
    }
}
