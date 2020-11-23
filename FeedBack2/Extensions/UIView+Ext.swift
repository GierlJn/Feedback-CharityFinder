//
//  UIView+Extensions.swift
//  FeedBack2
//
//  Created by Julian Gierl on 05.10.20.
//  Copyright © 2020 Julian Gierl. All rights reserved.
//

import UIKit
import SnapKit

fileprivate var emptyStateView: EmptyStateView!

extension UIView{

    func showEmptyView(_ title: String){
        DispatchQueue.main.async {
        emptyStateView = EmptyStateView(title: title)
        self.addSubview(emptyStateView)
        emptyStateView.pinToEdges(of: self)
        }
    }
    
    func hideEmptyView(){
        if(emptyStateView != nil){
            DispatchQueue.main.async {
                emptyStateView.removeFromSuperview()
                emptyStateView = nil
            }
        }
    }
    
    func pinToEdges(of superView: UIView){
        self.snp.makeConstraints { (make) in
            make.top.equalTo(superView.snp.top)
            make.left.equalTo(superView.snp.left)
            make.right.equalTo(superView.snp.right)
            make.bottom.equalTo(superView.snp.bottom)
        }
    }
    
    func addSubviews(_ views: UIView...){
        for view in views{
            addSubview(view)
        }
    }
    
    func applyViewShadow(){
        self.layoutIfNeeded()
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2.5)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 0.2
        layer.masksToBounds = false
    }
}

//MARK: GradientBackground

extension UIView {

    enum axis {
        case vertical, horizontal, custom(angle: CGFloat)
    }
    
    func removeGradientBackground(){
        layer.sublayers?.filter { $0.name == "gradientLayer" }.forEach { $0.removeFromSuperlayer() }
    }

    func setGradientBackgroundColor(colors: [UIColor], axis: axis, cornerRadius: CGFloat? = nil, apply: ((UIView) -> ())? = nil) {
        layer.sublayers?.filter { $0.name == "gradientLayer" }.forEach { $0.removeFromSuperlayer() }
        self.layoutIfNeeded()

        let cgColors = colors.map { $0.cgColor }

        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = cgColors
        gradient.name = "gradientLayer"
        gradient.locations = [0.0, 1.0]

        switch axis {
            case .horizontal:
                gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
                gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
            case .custom(let angle):
                calculatePoints(for: angle, gradient: gradient)
            default:
                break
        }

        gradient.frame = self.bounds
        self.layer.insertSublayer(gradient, at: 0)

        guard let cornerRadius = cornerRadius else { return }

        let circularPath = CGMutablePath()

        circularPath.move(to: CGPoint.init(x: cornerRadius, y: 0))
        circularPath.addLine(to: CGPoint.init(x: self.bounds.width - cornerRadius, y: 0))
        circularPath.addQuadCurve(to: CGPoint.init(x: self.bounds.width, y: cornerRadius), control: CGPoint.init(x: self.bounds.width, y: 0))
        circularPath.addLine(to: CGPoint.init(x: self.bounds.width, y: self.bounds.height - cornerRadius))
        circularPath.addQuadCurve(to: CGPoint.init(x: self.bounds.width - cornerRadius, y: self.bounds.height), control: CGPoint.init(x: self.bounds.width, y: self.bounds.height))
        circularPath.addLine(to: CGPoint.init(x: cornerRadius, y: self.bounds.height))
        circularPath.addQuadCurve(to: CGPoint.init(x: 0, y: self.bounds.height - cornerRadius), control: CGPoint.init(x: 0, y: self.bounds.height))
        circularPath.addLine(to: CGPoint.init(x: 0, y: cornerRadius))
        circularPath.addQuadCurve(to: CGPoint.init(x: cornerRadius, y: 0), control: CGPoint.init(x: 0, y: 0))


        let maskLayer = CAShapeLayer()
        maskLayer.path = circularPath
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        maskLayer.fillColor = UIColor.red.cgColor
        self.layer.mask = maskLayer

        apply?(self)
    }

    func calculatePoints(for angle: CGFloat, gradient: CAGradientLayer) {

        var ang = (-angle).truncatingRemainder(dividingBy: 360)
        if ang < 0 { ang = 360 + ang }
        let n: CGFloat = 0.5

        switch ang {
            case 0...45, 315...360:
                let a = CGPoint(x: 0, y: n * tanx(ang) + n)
                let b = CGPoint(x: 1, y: n * tanx(-ang) + n)
                gradient.startPoint = a
                gradient.endPoint = b
            case 45...135:
                let a = CGPoint(x: n * tanx(ang - 90) + n, y: 1)
                let b = CGPoint(x: n * tanx(-ang - 90) + n, y: 0)
                gradient.startPoint = a
                gradient.endPoint = b
            case 135...225:
                let a = CGPoint(x: 1, y: n * tanx(-ang) + n)
                let b = CGPoint(x: 0, y: n * tanx(ang) + n)
                gradient.startPoint = a
                gradient.endPoint = b
            case 225...315:
                let a = CGPoint(x: n * tanx(-ang - 90) + n, y: 0)
                let b = CGPoint(x: n * tanx(ang - 90) + n, y: 1)
                gradient.startPoint = a
                gradient.endPoint = b
            default:
                let a = CGPoint(x: 0, y: n)
                let b = CGPoint(x: 1, y: n)
                gradient.startPoint = a
                gradient.endPoint = b

        }
    }

    private func tanx(_ 𝜽: CGFloat) -> CGFloat {
        return tan(𝜽 * CGFloat.pi / 180)
    }
    
    //MARK: Round corners
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
             let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
             let mask = CAShapeLayer()
             mask.path = path.cgPath
             self.layer.mask = mask
        }
}
