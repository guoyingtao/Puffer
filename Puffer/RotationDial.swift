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
    
    private var dialPlate: RotationAngleIndicator?
    private var dialPlateHolder: UIView?
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
        
        dialPlateHolder?.removeFromSuperview()
        dialPlateHolder = getDialPlateHolder(byOrientation: config.orientation)
        addSubview(dialPlateHolder!)
        createDialPlate(byContainer: dialPlateHolder!)
        setupPointer(byContainer: dialPlateHolder!)
        
        setDialPlateHolder(byOrientation: config.orientation)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func getDialPlateHolder(byOrientation orientation: Puffer.Orientation) -> UIView {
        let view = UIView(frame: bounds)
        
        switch orientation {
        case .normal, .upsideDown:
            ()
        case .left, .right:
            view.frame.size = CGSize(width: view.bounds.height, height: view.bounds.width)
        }
        
        return view
    }
    
    private func setDialPlateHolder(byOrientation orientation: Puffer.Orientation) {
        switch orientation {
        case .normal:
            ()
        case .left:
            dialPlateHolder?.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
            dialPlateHolder?.frame.origin = CGPoint(x: 0, y: 0)
        case .right:
            dialPlateHolder?.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
            dialPlateHolder?.frame.origin = CGPoint(x: 0, y: 0)
        case .upsideDown:
            dialPlateHolder?.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            dialPlateHolder?.frame.origin = CGPoint(x: 0, y: 0)
        }
    }
    
    private func createDialPlate(byContainer container: UIView) {
        var margin: CGFloat = CGFloat(config.margin)
        if case .limit(let degree) = config.degreeShowLimit {
            margin = 0
            showRadiansLimit = CGFloat(degree) * CGFloat.pi / 180
        } else {
            showRadiansLimit = CGFloat.pi
        }

        var dialPlateShowHeight = container.frame.height - margin - pointerHeight - spanBetweenDialPlateAndPointer
        var r = dialPlateShowHeight / (1 - cos(showRadiansLimit))
        
        if r * 2 * sin(showRadiansLimit) > container.frame.width {
            r = (container.frame.width / 2) / sin(showRadiansLimit)
            dialPlateShowHeight = r - r * cos(showRadiansLimit)
        }
        
        let dialPlateLength = 2 * r
        let dialPlateFrame = CGRect(x: (container.frame.width - dialPlateLength) / 2, y: margin - (dialPlateLength - dialPlateShowHeight), width: dialPlateLength, height: dialPlateLength)
        
        dialPlate?.removeFromSuperview()
        dialPlate = RotationAngleIndicator(frame: dialPlateFrame, config: config)
        container.addSubview(dialPlate!)
    }
    
    private func setupPointer(byContainer container: UIView){
        guard let dialPlate = dialPlate else { return }
        
        let path = CGMutablePath()
        
        let pointerEdgeLength: CGFloat = pointerHeight * sqrt(2)
        
        let pointTop = CGPoint(x: container.bounds.width/2, y: dialPlate.frame.maxY + pointerHeight)
        let pointLeft = CGPoint(x: container.bounds.width/2 - pointerEdgeLength / 2, y: pointTop.y + pointerHeight)
        let pointRight = CGPoint(x: container.bounds.width/2 + pointerEdgeLength / 2, y: pointLeft.y)
        
        path.move(to: pointTop)
        path.addLine(to: pointLeft)
        path.addLine(to: pointRight)
        path.addLine(to: pointTop)
        pointer.fillColor = config.indicatorColor.cgColor
        pointer.path = path
        container.layer.addSublayer(pointer)
    }
    
    func getRotationCenter() -> CGPoint {
        guard let dialPlate = dialPlate else { return .zero }
        
        if rotationCenter == .zero {
            let p = CGPoint(x: dialPlate.bounds.midX , y: dialPlate.bounds.midY)
            return dialPlate.convert(p, to: self)
        } else {
            return rotationCenter
        }
    }
}

// Public API
extension RotationDial {
    
    @discardableResult
    func rotateDialPlate(byRadians radians: CGFloat) -> Bool {
        guard let dialPlate = dialPlate else { return false }
        
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
            dialPlate?.transform = CGAffineTransform(rotationAngle: radians)
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
        guard let dialPlate = dialPlate else { return 0 }
        
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
