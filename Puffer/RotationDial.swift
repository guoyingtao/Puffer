//
//  AngleDashboard.swift
//  Mantis
//
//  Created by Echo on 10/21/18.
//  Copyright © 2018 Echo. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
//  IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import UIKit

public class RotationDial: UIView {
    
    var rotationCenter: CGPoint = .zero
    
    var radiansLimit: CGFloat = 45 * CGFloat.pi / 180
    
    var showRadiansLimit: CGFloat = 37.5 * CGFloat.pi / 180
    let pointerHeight: CGFloat = 8
    let spanBetweenDialPlateAndPointer: CGFloat = 6
    
    private var dialPlate: RotationAngleIndicator!
    private var pointer: CAShapeLayer = CAShapeLayer()
    
    fileprivate var rotationCal: RotationCalculator?
    fileprivate var currentPoint: CGPoint?
    fileprivate var previousPoint: CGPoint?
    
    var config = Puffer.Config()
    
    public init(frame: CGRect, config: Puffer.Config = Puffer.Config()) {
        super.init(frame: frame)        
        setup(config: config)
    }
    
    public func setup(config: Puffer.Config = Puffer.Config()) {
        clipsToBounds = true
        backgroundColor = config.backgroundColor
        
        self.config = config
        
        if case .limit(let degree) = config.rotationLimit {
            radiansLimit = CGFloat(degree) * CGFloat.pi / 180
        }
        
        var margin: CGFloat = CGFloat(config.margin)
        if case .limit(let degree) = config.degreeShowLimit {
            margin = 0
            showRadiansLimit = CGFloat(degree) * CGFloat.pi / 180
        } else {
            showRadiansLimit = CGFloat.pi
        }
        
        var dialPlateShowHeight = frame.height - margin - pointerHeight - spanBetweenDialPlateAndPointer
        var r = dialPlateShowHeight / (1 - cos(showRadiansLimit))
        
        if r * 2 * sin(showRadiansLimit) > frame.width {
            r = (frame.width / 2) / sin(showRadiansLimit)
            dialPlateShowHeight = r - r * cos(showRadiansLimit)
        }
        
        let dialPlateLength = 2 * r
        let dialPlateFrame = CGRect(x: (frame.width - dialPlateLength) / 2, y: margin - (dialPlateLength - dialPlateShowHeight), width: dialPlateLength, height: dialPlateLength)
        
        if dialPlate != nil {
            dialPlate.removeFromSuperview()
        }
        
        dialPlate = RotationAngleIndicator(frame: dialPlateFrame, config: config)
        addSubview(dialPlate)
        
        setupPointer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupPointer(){
        let path = CGMutablePath()
        
        let pointerEdgeLength: CGFloat = pointerHeight * sqrt(2)
        
        let pointTop = CGPoint(x: bounds.width/2, y: dialPlate.frame.maxY + pointerHeight)
        let pointLeft = CGPoint(x: bounds.width/2 - pointerEdgeLength / 2, y: pointTop.y + pointerHeight)
        let pointRight = CGPoint(x: bounds.width/2 + pointerEdgeLength / 2, y: pointLeft.y)
        
        path.move(to: pointTop)
        path.addLine(to: pointLeft)
        path.addLine(to: pointRight)
        path.addLine(to: pointTop)
        pointer.fillColor = config.indicatorColor.cgColor
        pointer.path = path
        layer.addSublayer(pointer)
    }
    
    func getRotationCenter() -> CGPoint {
        if rotationCenter == .zero {
            return CGPoint(x: dialPlate.frame.midX , y: dialPlate.frame.midY)
        } else {
            return rotationCenter
        }
    }
}

// Public API
extension RotationDial {
    
    @discardableResult
    func rotateDialPlate(byRadians radians: CGFloat) -> Bool {
        if case .limit = config.rotationLimit {
            if (getRotationRadians() * radians) > 0 && abs(getRotationRadians() + radians) >= radiansLimit {
                return false
            }
        }
        
        dialPlate.transform = dialPlate.transform.rotated(by: radians)
        return true
    }
    
    public func rotateDialPlate(toRadians radians: CGFloat, animated: Bool = false) {
        if case .limit = config.rotationLimit {
            guard abs(radians) < radiansLimit else {
                return
            }
        }
        
        func rotate() {
            dialPlate.transform = CGAffineTransform(rotationAngle: radians)
        }
        
        if animated {
            UIView.animate(withDuration: 0.5) {
                rotate()
            }
        } else {
            rotate()
        }
    }
    
    public func resetAngle(animated: Bool) {
        rotateDialPlate(toRadians: 0, animated: animated)
    }
    
    public func getRotationRadians() -> CGFloat {
        return CGFloat(atan2f(Float(dialPlate.transform.b), Float(dialPlate.transform.a)))
    }
    
    public func getRotationDegrees() -> CGFloat {
        return getRotationRadians() * 180 / CGFloat.pi
    }
}

extension RotationDial {
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let p = convert(point, to: self)
        
        if bounds.contains(p) {
            return self
        }
        
        return nil
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard touches.count == 1, let touch = touches.first else {
            return
        }
        
        let point = touch.location(in: self)
        rotationCal = RotationCalculator(midPoint: getRotationCenter())
        currentPoint = point
        previousPoint = point
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        guard touches.count == 1, let touch = touches.first else {
            return
        }
        
        let point = touch.location(in: self)
        
        currentPoint = point
        if let radians = rotationCal?.getRotationRadians(byOldPoint: previousPoint!, andNewPoint: currentPoint!) {
            
            if case .limit = config.rotationLimit {
                guard radians <= radiansLimit else {
                    return
                }
            }
            
            guard rotateDialPlate(byRadians: radians) == true else {
                return
            }
        }
        
        previousPoint = currentPoint
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        currentPoint = nil
        previousPoint = nil
        rotationCal = nil
    }
}
