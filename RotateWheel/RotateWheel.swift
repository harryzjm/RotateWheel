//
//  RotateWheel.swift
//  Sample
//
//  Created by Magic on 30/6/2016.
//  Copyright © 2016 Magic. All rights reserved.
//

import Foundation
import UIKit

class PieceCell: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.anchorPoint = CGPoint(x: 1, y: 0.5)
        userInteractionEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol RotateWheelDelegate {
    func rotateWheel(rotateWheel: RotateWheel, configCell cell: PieceCell, forPiece piece: Int)
    func rotateWheel(rotateWheel: RotateWheel, didSelectCell cell: PieceCell, forPiece piece: Int)
}

class RotateWheel: UIControl {
    var piece: Int = 0
    
    var pieceAngle: CGFloat { return 2 * CGFloat( M_PI ) / CGFloat( piece ) }
    var radius: CGFloat { return min(bounds.width, bounds.height) / 2 }
    
    var startAngle: CGFloat = 0
    var startTransform = CGAffineTransformIdentity
    
    init(_ cellPiece: Int, frame: CGRect = CGRectZero) {
        super.init(frame: frame)
        
        piece = cellPiece
        initUI()
        
        refreshUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- UI
    func initUI() {
        addSubview(container)
        container.snp_makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    lazy var container: UIView = {
        let v = UIView()
        v.userInteractionEnabled = false
        return v
    }()
    
    func refreshUI() {
        (0 ..< piece).forEach { (i) in
            let rt = CGRect(x: 0, y: 0, width: radius, height: radius * 2/3)
            let v = PieceCell(frame: rt)
            v.layer.position = CGPoint(x: radius, y: radius)
            v.transform = CGAffineTransformMakeRotation(pieceAngle * CGFloat(i))
            v.backgroundColor = UIColor(hue: CGFloat( arc4random_uniform(255) ) / 255, saturation: 1, brightness: 1, alpha: 1)
            
            container.addSubview(v)
        }
    }
    
    override func layoutSubviews() {
        container.subviews.forEach { $0.removeFromSuperview() }
        super.layoutSubviews()
        print("layoutSubviews")
        refreshUI()
    }
    
//    func transformParameterView()
//    {
//        for (UIView *tmpV in _inforDic.allValues) {
//            CGAffineTransform containerTransfrom = CGAffineTransformInvert(tmpV.superview.transform);
//            CGAffineTransform selfTransfrom = CGAffineTransformInvert(tmpV.superview.superview.transform);
//            tmpV.transform = CGAffineTransformRotate(CGAffineTransformConcat(containerTransfrom, selfTransfrom), M_PI_2);
//        }
//    }
}

extension RotateWheel {
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        let beginPoint = touch.locationInView(self)
        
        startAngle = atan2(beginPoint.y - container.center.y, beginPoint.x - container.center.x)
        startTransform = container.transform
        return true
    }
    
    override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        let point = touch.locationInView(self)
        
        let angleDifference = atan2(point.y - container.center.y, point.x - container.center.x) - startAngle
        container.transform = CGAffineTransformRotate(startTransform, angleDifference)
        
        return true
    }
    
    override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        endTrack()
    }
    
    override func cancelTrackingWithEvent(event: UIEvent?) {
        endTrack()
    }
    
    func endTrack() {
        let angle = atan2(container.transform.b, container.transform.a) % pieceAngle
        
        var value: CGFloat = 0
        if angle > 0 {
            value = angle > pieceAngle/2 ? pieceAngle - angle:-angle
        } else {
            value = -angle > pieceAngle/2 ? -angle - pieceAngle:-angle
        }
        
        UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseIn, animations: {
            [weak self] in
            guard let wSelf = self else { return }
            wSelf.container.transform = CGAffineTransformRotate(wSelf.container.transform, value)
            }, completion: nil)
    }
}












