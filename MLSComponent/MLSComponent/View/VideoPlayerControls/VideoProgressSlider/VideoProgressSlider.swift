//
// Copyright © 2020 mycujoo. All rights reserved.
//

import UIKit

class VideoProgressSlider: UIControl {
    
    //MARK: - Properties
    
    private var _value: Double = 0.0 {
        didSet { updateLayerFrames() }
    }
    
    var value: Double {
        get { _value }
        set {
            guard !isTracking else { return }
            _value = newValue
            updateLayerFrames()
        }
    }
    
    private let minimumValue = 0.0
    private let maximumValue = 1.0

    private let timeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        view.backgroundColor = UIColor.blue.withAlphaComponent(0.5)
        view.heightAnchor.constraint(equalToConstant: 16).isActive = true
        return view
    }()

    private let trackView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        view.backgroundColor = .green
        view.heightAnchor.constraint(equalToConstant: 16).isActive = true
        return view
    }()

    private lazy var trailingConstraintOfTrackView: NSLayoutConstraint = {
        trackView.trailingAnchor.constraint(equalTo: leadingAnchor)
    }()

    private let thumbLayer = ThumbLayer()
    private var previousLocation = CGPoint()
    
    var thumbTintColor = UIColor.white
    
    private var thumbWidth: CGFloat {
        return 8
    }
    
    private var trackHeight: CGFloat {
        return 6
    }
    
    override var frame: CGRect {
        didSet {
            updateLayerFrames()
        }
    }
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        drawSelf()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        drawSelf()
    }
    
    //MARK: - Draw
    
    override func layoutSubviews() {
        updateLayerFrames()
    }
    
    private func drawSelf() {

        addSubview(timeView)
        NSLayoutConstraint
            .activate(
            [
                timeView.leadingAnchor.constraint(equalTo: leadingAnchor),
                timeView.trailingAnchor.constraint(equalTo: trailingAnchor),
                timeView.centerYAnchor.constraint(equalTo: centerYAnchor)
            ]
        )

        addSubview(trackView)
        NSLayoutConstraint
            .activate(
            [
                trackView.leadingAnchor.constraint(equalTo: leadingAnchor),
                trailingConstraintOfTrackView,
                trackView.centerYAnchor.constraint(equalTo: centerYAnchor)
            ]
        )
        
        thumbLayer.contentsScale = UIScreen.main.scale
        thumbLayer.slider = self
        layer.addSublayer(thumbLayer)
    }
    
    private func updateLayerFrames() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        let thumbCenter = CGFloat(position(forValue: value, withDelta: thumbWidth))
        thumbLayer.frame = CGRect(x: thumbCenter - thumbWidth / 2.0, y: (bounds.size.height - thumbWidth) / 2, width: thumbWidth, height: thumbWidth)
        thumbLayer.setNeedsDisplay()
        CATransaction.commit()
        trailingConstraintOfTrackView.constant = thumbCenter
    }
    
    private func position(forValue value: Double, withDelta delta: CGFloat = 0) -> Double {
        return Double(bounds.size.width - delta) * (value - minimumValue) / (maximumValue - minimumValue) + Double(delta / 2.0)
    }
    
    //MARK: - Touching
    
    private func bound(value: Double, toLowerValue lowerValue: Double, upperValue: Double) -> Double {
        return min(max(value, lowerValue), upperValue)
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        previousLocation = touch.location(in: self)
        
        if thumbLayer.frame.insetBy(dx: -20, dy: -20).contains(previousLocation) {
            thumbLayer.isHighlighted = true
        }
        
        return thumbLayer.isHighlighted
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        
        let deltaLocation = Double(location.x - previousLocation.x)
        let deltaValue = (maximumValue - minimumValue) * deltaLocation / Double(bounds.width - thumbWidth)
        
        previousLocation = location
        
        if thumbLayer.isHighlighted {
            
            _value += deltaValue
            _value = bound(value: _value, toLowerValue: minimumValue, upperValue: maximumValue)
            
        }
        
        sendActions(for: .valueChanged)
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        thumbLayer.isHighlighted = false
    }
}
