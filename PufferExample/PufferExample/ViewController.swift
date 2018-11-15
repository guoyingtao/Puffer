//
//  ViewController.swift
//  PufferExample
//
//  Created by Echo on 11/12/18.
//  Copyright © 2018 Echo. All rights reserved.
//

import UIKit
import Puffer

class ViewController: UIViewController {

    @IBOutlet weak var dial: RotationDial!
    @IBOutlet weak var roateAngleValue: UILabel!
    @IBOutlet weak var customRotationView: UIView!
    
    var orientation: Puffer.Orientation = .normal
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customRotationView.isHidden = true
        
        let config = Puffer.Config()
        dial.setup(config: config)
        
        dial.didRotate = {[weak self] angle in
            guard let self = self else { return }
            
            self.roateAngleValue.text = String(format:"%0.02f°", angle)
            
            if self.customRotationView.isHidden == false {
                self.customRotationView.transform = CGAffineTransform(rotationAngle: self.dial.getRotationRadians())
            }
        }
    }
    
    private func resetStatus() {
        customRotationView.isHidden = true
        roateAngleValue.text = "0°"
    }
    
    @IBAction func color(_ sender: Any) {
        resetStatus()
        
        var config = Puffer.Config()
        config.numberShowSpan = 2
        config.centerAxisColor = .yellow
        config.bigScaleColor = .blue
        config.smallScaleColor = .red
        config.indicatorColor = .brown
        config.numberColor = .purple
        config.backgroundColor = .lightGray
        
        dial.setup(config: config)
    }
    
    @IBAction func reset(_ sender: Any) {
        resetStatus()
        
        let config = Puffer.Config()
        dial.setup(config: config)
    }
    
    @IBAction func rotateLimit(_ sender: Any) {
        resetStatus()
        
        var config = Puffer.Config()
        config.rotationLimitType = .limit(degree: 45)

        dial.setup(config: config)
    }
    
    @IBAction func showLimit(_ sender: Any) {
        resetStatus()
        
        var config = Puffer.Config()
        config.degreeShowLimitType = .limit(degree: 60)
        
        dial.setup(config: config)
    }
    
    @IBAction func changeOrientation(_ sender: Any) {
        resetStatus()
        
        var config = Puffer.Config()
        config.degreeShowLimitType = .limit(degree: 60)
        
        if orientation == .normal {
            config.orientation = .left
        } else if orientation == .left {
            config.orientation = .upsideDown
        } else if orientation == .upsideDown {
            config.orientation = .right
        } else if orientation == .right {
            config.orientation = .normal
        }
        
        orientation = config.orientation
        dial.setup(config: config)
    }
    
    
    @IBAction func testCenter(_ sender: Any) {
        resetStatus()
        customRotationView.transform = .identity
        customRotationView.isHidden = false
        
        dial.setRotationCenter(byCenterPoint: customRotationView.center, inView: self.view)
        
        let config = Puffer.Config()
        dial.setup(config: config)
    }
}

