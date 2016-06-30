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
        
        view.addSubview(rw)
        rw.snp_makeConstraints { (make) in
            make.center.equalTo(view)
            make.width.height.equalTo(300)
        }
    }
    
    lazy var rw: RotateWheel = {
        //        let v = RotateWheel(7, frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        let v = RotateWheel(7)
        v.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
        return v
    }()
}

