//
//  RotationCalculator.swift
//  RotationCalculator
//
//  Created by Michael Teeuw on 20-06-14.
//  https://github.com/MichMich/XMCircleGestureRecognizer
//  Modified by Yingtao Guo on 10/21/18 (Adapted to the newest swift)
//  Copyright (c) 2014 Michael Teeuw. All rights reserved.
//
import UIKit

let π = CGFloat.pi

extension CGFloat {
    var degrees:CGFloat {
        return self * 180 / π;
    }
    var radians:CGFloat {
        return self * π / 180;
    }
    var rad2deg:CGFloat {
        return self.degrees
    }
    var deg2rad:CGFloat {
        return self.radians
    }
}

class RotationCalculator {
    
    // midpoint for gesture recognizer
    var midPoint = CGPoint.zero
    
    // minimal distance from midpoint
    var innerRadius:CGFloat?
    
    // maximal distance to midpoint
    var outerRadius:CGFloat?
    
    // relative rotation for current gesture (in radians)
    var rotation: CGFloat? {
        guard let currentPoint = self.currentPoint,
            let previousPoint = self.previousPoint else {
            return nil
        }
        
        var rotation = angleBetween(pointA: currentPoint, andPointB: previousPoint)
        
        if (rotation > π) {
            rotation -= π*2
        } else if (rotation < -π) {
            rotation += π*2
        }
        
        return rotation
    }
    
    // absolute angle for current gesture (in radians)
    var angle:CGFloat? {
        if let nowPoint = self.currentPoint {
            return self.angleForPoint(point: nowPoint)
        }
        
        return nil
    }
    
    // distance from midpoint
    var distance: CGFloat? {
        if let nowPoint = self.currentPoint {
            return self.distanceBetween(pointA: self.midPoint, andPointB: nowPoint)
        }
        
        return nil
    }
    
    private var currentPoint:CGPoint?
    private var previousPoint:CGPoint?
    
    init(midPoint: CGPoint) {
        self.midPoint = midPoint
    }
    
    private func distanceBetween(pointA:CGPoint, andPointB pointB:CGPoint) -> CGFloat {
        let dx = Float(pointA.x - pointB.x)
        let dy = Float(pointA.y - pointB.y)
        return CGFloat(sqrtf(dx*dx + dy*dy))
    }
    
    private func angleForPoint(point:CGPoint) -> CGFloat {
        var angle = CGFloat(-atan2f(Float(point.x - midPoint.x), Float(point.y - midPoint.y))) + π/2
        
        
        if (angle < 0) {
            angle += π*2;
        }
        
        
        return angle
    }
    
    private func angleBetween(pointA:CGPoint, andPointB pointB:CGPoint) -> CGFloat {
        return angleForPoint(point: pointA) - angleForPoint(point: pointB)
    }
    
    func getRotationRadians(byOldPoint p1:CGPoint, andNewPoint p2: CGPoint) -> CGFloat {
        self.previousPoint = p1
        self.currentPoint = p2
        return rotation ?? 0
    }
}
