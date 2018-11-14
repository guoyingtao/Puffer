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

    @IBOutlet weak var dial1: RotationDial!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var config = Puffer.Config()
        config.numberShowSpan = 2
        config.rotationLimit = .limit(degree: 45)
        config.degreeShowLimit = .limit(degree: 60)
        dial1.setup(config: config)
    }    
}

