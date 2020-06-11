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

    private let highlightView: UIView = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = false
        label.backgroundColor = .green
        label.text = "highlight"
        label.isHidden = true
        return label
    }()

    private lazy var centerXConstraintOfHighlight: NSLayoutConstraint = {
        highlightView.centerXAnchor.constraint(equalTo: leadingAnchor)
    }()

    private var timelineMarkers: [CGFloat] = []
    
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

        addSubview(highlightView)
        highlightView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 16).isActive = true
        centerXConstraintOfHighlight.isActive = true
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

        let highlightValue = timelineMarkers.first { moment in
            ((value - 0.1)...(value + 0.1)).contains(Double(moment))
        }

        if let highlightValue = highlightValue {
            highlightView.isHidden = false
            centerXConstraintOfHighlight.constant = bounds.width * CGFloat(highlightValue)
        } else {
            highlightView.isHidden = true
        }

        return true
    }
}

extension VideoProgressSlider {
    func addTimelineMarker(moment: Double, color: UIColor) {
        timelineMarkers.append(CGFloat(moment))
        let highlight = UIView()
        highlight.isUserInteractionEnabled = false
        highlight.translatesAutoresizingMaskIntoConstraints = false
        highlight.backgroundColor = color
        addSubview(highlight)
        highlight.heightAnchor.constraint(equalTo: timeView.heightAnchor).isActive = true
        highlight.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        highlight.widthAnchor.constraint(equalToConstant: 4).isActive = true
        let minimumPossibleMultiplier: CGFloat = 0.001
        let centerXOfView: CGFloat = 2
        addConstraint(
            NSLayoutConstraint(
                item: highlight,
                attribute: .centerX,
                relatedBy: .equal,
                toItem: self,
                attribute: .centerX,
                multiplier: max(minimumPossibleMultiplier, centerXOfView * CGFloat(moment)),
                constant: 0
            )
        )
        bringSubviewToFront(thumbView)
    }
}
