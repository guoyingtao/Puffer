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
    
    var orientation: Puffer.Orientation = .normal
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let config = Puffer.Config()
        dial.setup(config: config)
        
        dial.didRotate = {[weak self] angle in
            self?.roateAngleValue.text = String(format:"%0.02f°", angle)
        }
    }
    
    private func resetAngleValueLabel() {
        roateAngleValue.text = "0°"
    }
    
    @IBAction func color(_ sender: Any) {
        resetAngleValueLabel()
        
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
        resetAngleValueLabel()
        
        let config = Puffer.Config()
        dial.setup(config: config)
    }
    
    @IBAction func rotateLimit(_ sender: Any) {
        resetAngleValueLabel()
        
        var config = Puffer.Config()
        config.rotationLimit = .limit(degree: 45)

        dial.setup(config: config)
    }
    
    @IBAction func showLimit(_ sender: Any) {
        resetAngleValueLabel()
        
        var config = Puffer.Config()
        config.degreeShowLimit = .limit(degree: 60)
        
        dial.setup(config: config)
    }
    
    @IBAction func changeOrientation(_ sender: Any) {
        resetAngleValueLabel()
        
        var config = Puffer.Config()
        config.degreeShowLimit = .limit(degree: 60)
        
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
}

