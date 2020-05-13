//
// Copyright © 2020 mycujoo. All rights reserved.
//

import UIKit

extension VideoProgressSlider {
    
    class ThumbLayer: CALayer {
        
        var isHighlighted = false {
            didSet {
                setNeedsDisplay()
            }
        }
        
        weak var slider: VideoProgressSlider?
        
        override func draw(in ctx: CGContext) {
            
            guard let slider = slider else {
                return
            }
            
            let thumbFrame = bounds
            let cornerRadius = thumbFrame.height / 2.0
            let thumbPath = UIBezierPath(roundedRect: thumbFrame, cornerRadius: cornerRadius).cgPath
            
            //fill with subtle shadow
            let shadowColor10 = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
            let shadowColor5 = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.05).cgColor
            
            ctx.setShadow(offset: CGSize(width: 0, height: 2), blur: 1.0, color: shadowColor5)
            ctx.setShadow(offset: CGSize(width: 0, height: 1), blur: 1.0, color: shadowColor10)
            ctx.setShadow(offset: CGSize(width: 0, height: 2), blur: 2.0, color: shadowColor5)
            
            ctx.setFillColor(slider.thumbTintColor.cgColor)
            ctx.addPath(thumbPath)
            ctx.fillPath()

            //Outline
            ctx.setStrokeColor(shadowColor10)
            ctx.setLineWidth(0.5)
            ctx.addPath(thumbPath)
            ctx.strokePath()
            
        }
        
    }
    
}
