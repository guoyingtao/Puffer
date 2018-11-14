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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var config = Puffer.Config()
        dial.setup(config: config)
    }
    
    @IBAction func color(_ sender: Any) {
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
        let config = Puffer.Config()
        dial.setup(config: config)
    }
    
    @IBAction func rotateLimit(_ sender: Any) {
        var config = Puffer.Config()
        config.rotationLimit = .limit(degree: 45)

        dial.setup(config: config)
    }
    
    @IBAction func showLimit(_ sender: Any) {
        var config = Puffer.Config()
        config.degreeShowLimit = .limit(degree: 60)
        
        dial.setup(config: config)
    }
}

