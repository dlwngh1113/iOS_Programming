//
//  TouchEffectView.swift
//  TermProject
//
//  Created by kpugame on 2021/06/07.
//

import SwiftUI
import UIKit

class TouchEffectView: UIView
{
    private var emitter :CAEmitterLayer!
    override class var layerClass: AnyClass{
        return CAEmitterLayer.self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("use init(frame: ")
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        emitter = self.layer as! CAEmitterLayer
        emitter.emitterPosition = CGPoint(x: self.bounds.size.width / 2, y: self.bounds.size.height / 2)
        emitter.emitterSize = self.bounds.size
        emitter.renderMode = CAEmitterLayerRenderMode.additive
        emitter.emitterShape = CAEmitterLayerEmitterShape.rectangle
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if self.superview == nil
        {
            return
        }
        
        let texture:UIImage? = UIImage(named: "particle.png")
        assert(texture != nil, "particle image not found")
        
        let emitterCell = CAEmitterCell()
        
        emitterCell.name = "cell"
        emitterCell.contents = texture?.cgImage
        emitterCell.birthRate = 30
        emitterCell.lifetime = 0.5
        emitterCell.color = CGColor(red: CGFloat.random(in: 0.0..<1.0), green: CGFloat.random(in: 0.0..<1.0), blue: CGFloat.random(in: 0.0..<1.0), alpha: 0.8)
        emitterCell.redSpeed = -0.3
        emitterCell.greenSpeed = -0.3
        emitterCell.blueSpeed = -0.3
        emitterCell.velocity = 100
        emitterCell.velocityRange = 30
        emitterCell.scale = CGFloat(0.1)
        emitterCell.emissionRange = CGFloat(Double.pi * 2)
        emitter.emitterCells = [emitterCell]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.removeFromSuperview()
        })
    }
}
