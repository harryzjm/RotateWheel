//
//  ViewController.swift
//  Sample
//
//  Created by Magic on 9/5/2016.
//  Copyright © 2016 Magic. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteColor()
        title = "Sample"
        
        let v = RotateWheel(6,wheelRadius: 120,cellType: Rotate.self)
        v.delegate = self
        view.addSubview(v)
        v.center = view.center
    }
}

extension ViewController: RotateWheelDelegate {
    func rotateWheel(rotateWheel: RotateWheel, initCell cell: RotateWheelCell, forPiece piece: Int) {
        guard let c = cell as? Rotate else { return }
        
        c.lb.text = "gogo"
        c.lb.bounds.size = CGSize(width: 100, height: 50)
        let sz = c.container.bounds.size
        c.lb.center = CGPoint(x: sz.width/2, y: sz.height/2)
    }
    
    func rotateWheel(rotateWheel: RotateWheel, configCell cell: RotateWheelCell, forPiece piece: Int) {
        guard let c = cell as? Rotate else { return }
        
        c.lb.text = "gogo"
        c.lb.sizeToFit()
        let sz = c.container.bounds.size
        c.lb.center = CGPoint(x: sz.width/2, y: sz.height/2)
        
    }
    
}

class Rotate: RotateWheelCell {
     required init(frame: CGRect) {
        super.init(frame: frame)
        lb.textAlignment = .Center
        container.addSubview(lb)
        container.backgroundColor = UIColor(hue: CGFloat(arc4random_uniform(255))/255, saturation: 1, brightness: 1, alpha: 1).colorWithAlphaComponent(0.3)
    }
    
    var lb = UILabel()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
