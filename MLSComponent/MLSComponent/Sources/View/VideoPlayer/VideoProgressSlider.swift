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

    let timeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        view.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        view.heightAnchor.constraint(equalToConstant: 2).isActive = true
        view.layer.cornerRadius = 3
        return view
    }()

    let trackView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        view.backgroundColor = UIColor.white
        view.heightAnchor.constraint(equalToConstant: 2).isActive = true
        view.layer.cornerRadius = 3
        return view
    }()

    private lazy var trailingConstraintOfTrackView: NSLayoutConstraint = {
        trackView.trailingAnchor.constraint(equalTo: leadingAnchor)
    }()

    let thumbView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        view.backgroundColor = .white
        view.heightAnchor.constraint(equalToConstant: 10).isActive = true
        view.widthAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        view.layer.cornerRadius = 5
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
    private var markers: [String: (markerView: UIView, constraint: NSLayoutConstraint)] = [:]
    
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
    func setTimelineMarkers(with objects: [(position: Double, marker: TimelineMarker)]) {
        let minPossibleMultiplier: CGFloat = 0.001
        let maxPossibleMultiplier: CGFloat = 0.999
        let centerXOfView: CGFloat = 2

        // Remove markers that are not relevant anymore.
        let newMarkerIds = objects.map { $0.marker.id }
        for oldMarker in self.markers {
            if !newMarkerIds.contains(oldMarker.key) {
                oldMarker.value.markerView.removeFromSuperview()
                self.markers[oldMarker.key] = nil
            }
        }

        for object in objects {
            if let oldMarker = self.markers[object.marker.id] {
                let oldConstraint = oldMarker.constraint
                let newConstraint = oldConstraint.constraintWithMultiplier(min(max(minPossibleMultiplier, centerXOfView * CGFloat(object.position)), maxPossibleMultiplier))
                // Set to low to avoid messing with the slider layout if at the edges
                newConstraint.priority = .defaultLow

                oldConstraint.isActive = false
                newConstraint.isActive = true
            } else {
                let markerView = UIView()
                markerView.isUserInteractionEnabled = false
                markerView.translatesAutoresizingMaskIntoConstraints = false
                markerView.backgroundColor = object.marker.markerColor
                addSubview(markerView)
                markerView.heightAnchor.constraint(equalTo: timeView.heightAnchor).isActive = true
                markerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
                markerView.widthAnchor.constraint(equalToConstant: 3).isActive = true

                let constraint = NSLayoutConstraint(
                    item: markerView,
                    attribute: .centerX,
                    relatedBy: .equal,
                    toItem: self,
                    attribute: .centerX,
                    multiplier: min(max(minPossibleMultiplier, centerXOfView * CGFloat(object.position)), maxPossibleMultiplier),
                    constant: 0
                )
                // Set to low to avoid messing with the slider layout if at the edges
                constraint.priority = .defaultLow
                constraint.isActive = true

                self.markers[object.marker.id] = (markerView: markerView, constraint: constraint)
            }
        }

        bringSubviewToFront(thumbView)

        layoutIfNeeded()
    }
}
