//
//  RotateWheel.swift
//  Sample
//
//  Created by Magic on 30/6/2016.
//  Copyright © 2016 Magic. All rights reserved.
//

import Foundation
import UIKit

public class RotateWheelCell: UIView {
    
    override required public init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.anchorPoint = CGPoint(x: 1, y: 0.5)
        userInteractionEnabled = false
        
        addSubview(container)
    }
    
    public lazy var container: UIView = {
        let v = UIView()
        return v
    }()
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

@objc public protocol RotateWheelDelegate {
    optional func rotateWheel(rotateWheel: RotateWheel, initCell cell: RotateWheelCell, forPiece piece: Int)
    optional func rotateWheel(rotateWheel: RotateWheel, configCell cell: RotateWheelCell, forPiece piece: Int)
}

public class RotateWheel: UIControl {
    private var startAngle: CGFloat = 0
    private var startTransform = CGAffineTransformIdentity
    public var delegate: RotateWheelDelegate?
    
    private var type: RotateWheelCell.Type
    public var piece: Int {
        didSet { setNeedsLayout();layoutIfNeeded() }
    }
    private var pieceAngle: CGFloat { return 2 * CGFloat( M_PI ) / CGFloat( piece ) }
    public var radius: CGFloat {
        didSet {
            bounds = CGRect(x: 0, y: 0, width: radius * 2, height: radius * 2)
            refreshUI()
        }
    }
    
    public init(_ cellPiece: Int, wheelRadius: CGFloat = 100, cellType: RotateWheelCell.Type = RotateWheelCell.self) {
        piece = cellPiece
        radius = wheelRadius
        type = cellType
        super.init(frame: CGRect(x: 0, y: 0, width: radius * 2, height: radius * 2))
        
        initUI()
        refreshUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- UI
    private func initUI() {
        addSubview(container)
        addConstraints([
            NSLayoutConstraint(item: self, attribute: .Left, relatedBy: .Equal, toItem: container, attribute: .Left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self, attribute: .Right, relatedBy: .Equal, toItem: container, attribute: .Right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self, attribute: .Top, relatedBy: .Equal, toItem: container, attribute: .Top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self, attribute: .Bottom, relatedBy: .Equal, toItem: container, attribute: .Bottom, multiplier: 1, constant: 0)])
    }
    
    private lazy var container: UIView = {
        let v = UIView()
        v.userInteractionEnabled = false
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private func refreshUI() {
        container.subviews.forEach { $0.removeFromSuperview() }
        
        let width = rint(radius)
        let height = rint(radius * 2/3)
        
        (0 ..< piece).forEach { (i) in
            let rt = CGRect(x: 0, y: 0, width: width, height: height)
            let v = type.init(frame: rt)
            
            v.layer.position = CGPoint(x: radius, y: radius)
            v.transform = CGAffineTransformMakeRotation(pieceAngle * CGFloat(i))
            v.tag = i
            v.container.bounds = CGRect(x: 0, y: 0, width: width, height: width)
            v.container.center = v.center
            
            container.addSubview(v)
            
            delegate?.rotateWheel?(self, initCell: v, forPiece: i)
            delegate?.rotateWheel?(self, configCell: v, forPiece: i)
        }
        adaptSubview()
    }
    
    public func reloadData() {
        container.subviews.forEach { (view) in
            guard let cell = view as? RotateWheelCell else { return }
            delegate?.rotateWheel?(self, configCell: cell, forPiece: cell.tag)
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        refreshUI()
    }
    
    private func adaptSubview()
    {
        container.subviews.forEach { (view) in
            guard let cell = view as? RotateWheelCell else { return }
            let cellTra = CGAffineTransformInvert(cell.transform)
            let containerTra = CGAffineTransformInvert(container.transform)
            cell.container.transform = CGAffineTransformConcat(cellTra, containerTra)
        }
    }
}

extension RotateWheel {
    override public func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        let point = touch.locationInView(self)
        startAngle = atan2(point.y - container.center.y, point.x - container.center.x)
        startTransform = container.transform
        return true
    }
    
    override public func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        let point = touch.locationInView(self)
        let angleDifference = atan2(point.y - container.center.y, point.x - container.center.x) - startAngle
        container.transform = CGAffineTransformRotate(startTransform, angleDifference)
        adaptSubview()
        return true
    }
    
    override public func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        endTrack()
    }
    
    override public func cancelTrackingWithEvent(event: UIEvent?) {
        endTrack()
    }
    
    private func endTrack() {
        let angle = atan2(container.transform.b, container.transform.a) % pieceAngle
        let value = abs(angle) > pieceAngle/2 ? angle > 0 ? pieceAngle - angle:-angle - pieceAngle:-angle
        
        UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseIn, animations: {
            [weak self] in
            guard let wSelf = self else { return }
            wSelf.container.transform = CGAffineTransformRotate(wSelf.container.transform, value)
            wSelf.adaptSubview()
            }, completion: nil)
    }
}









