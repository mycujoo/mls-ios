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

    private let thumbView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        view.backgroundColor = .white
        view.heightAnchor.constraint(equalToConstant: 12).isActive = true
        view.widthAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        view.layer.cornerRadius = 6
        return view
    }()

    private lazy var centerXOfThumbView: NSLayoutConstraint = {
        thumbView.centerXAnchor.constraint(equalTo: leadingAnchor)
    }()
    
    var thumbTintColor = UIColor.white
    
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

        addSubview(thumbView)
        centerXOfThumbView.isActive = true
        thumbView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    private func updateLayerFrames() {
        let thumbCenter = bounds.width * CGFloat(value)
        trailingConstraintOfTrackView.constant = thumbCenter
        centerXOfThumbView.constant = thumbCenter
    }

    //MARK: - Touching
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        _value = Double(max(0, min(touch.location(in: self).x, bounds.width)) / bounds.width)
        sendActions(for: .valueChanged)
        return true
    }
}

extension VideoProgressSlider {
    func addHighlight(moment: Double, color: UIColor) {
        let highlight = UIView()
        highlight.isUserInteractionEnabled = false
        highlight.translatesAutoresizingMaskIntoConstraints = false
        highlight.backgroundColor = color
        addSubview(highlight)
        highlight.heightAnchor.constraint(equalTo: timeView.heightAnchor).isActive = true
        highlight.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        highlight.widthAnchor.constraint(equalToConstant: 4).isActive = true

        highlight.centerXAnchor.constraint(equalTo: leadingAnchor, constant: bounds.width * CGFloat(moment)).isActive = true
    }
}
