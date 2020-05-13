//
// Copyright © 2020 mycujoo. All rights reserved.
//

import UIKit

extension VideoProgressSlider {
    
    class TrackLayer: CALayer {
        
        var tintColor: CGColor?
        
        override func draw(in ctx: CGContext) {
            
            let tintColor = self.tintColor ?? UIColor.clear.cgColor
            
            //clip
            let cornerRadius = bounds.height / 2.0
            let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
            ctx.addPath(path.cgPath)

            //fill the track
            ctx.setFillColor(tintColor)
            ctx.addPath(path.cgPath)
            ctx.fillPath()
            
        }
        
    }
    
}
