//
//  GradientView.swift
//  LabsComplete
//
//  Created by Dzmitry Mukhliada on 12/23/18.
//  Copyright © 2018 Dzmitry Mukhliada. All rights reserved.
//

import UIKit

class GradientView: UIView {

    private var gradientLayer = CAGradientLayer()
    private var vertical: Bool = false
    public static var reverse: Bool = false
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        // Drawing code
        
        //fill view with gradient layer
        gradientLayer.frame = self.bounds
        
        //style and insert layer if not already inserted
        if gradientLayer.superlayer == nil {
            
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = vertical ? CGPoint(x: 0, y: 1) : CGPoint(x: 1, y: 0)
            gradientLayer.colors = [UIColor.red.cgColor, UIColor.yellow.cgColor, UIColor.green.cgColor]
            
            if GradientView.reverse {
                gradientLayer.locations = [1.0, 0.5, 0.0]
            } else {
                gradientLayer.locations = [0.0, 0.5, 1.0]
            }
            
            self.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    
    func image() -> UIImage {
        UIGraphicsBeginImageContext(self.frame.size)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return UIImage.init(cgImage: (image?.cgImage)!).withHorizontallyFlippedOrientation()
    }
}
