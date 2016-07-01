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
        
//        test()
    }
    
    func test() {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(3 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            self.rw.piece = Int(arc4random_uniform(10))
            self.test()
        }
    }
    
    lazy var rw: RotateWheel = {
        let v = RotateWheel(7)
        v.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
        return v
    }()
}

