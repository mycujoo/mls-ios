//
// Copyright © 2020 mycujoo. All rights reserved.
//

import UIKit

class VideoProgressSlider: UIControl {

    /// Describes how many points the thumb needs to be away from the center of a timeline marker before its bubble appears/disappears.
    private let showTimelineMarkerBubbleWithinPointRange: Double = 5.0
    
    //MARK: - Properties
    
    private var _value: Double = 0.0 {
        didSet { updateLayerFrames() }
    }
    
    var value: Double {
        get { _value }
        set {
            guard !isTracking else { return }
            _value = newValue
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

    /// A dictionary of marker ids (keys) to tuples (values). Each tuple contains:
    /// - a UIView that represents the timeline marker
    /// - a position (between 0 and 1) that describes its relative position on the seekbar
    /// - a constraint that is used to set its position. This could be derived from the markerView's layoutAnchors but its quicker to access this way.
    private var markers: [String: (markerView: UIView, position: Double, constraint: NSLayoutConstraint)] = [:]
    
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
        let width = Double(bounds.width)
        guard width > 0 else { return false }

        _value = max(0, min(Double(touch.location(in: self).x), width)) / width
        sendActions(for: .valueChanged)

        let rangeInterval = showTimelineMarkerBubbleWithinPointRange / width
        let moments = (markers.map { $0.value.position }).sorted()
        let highlightValue = moments.first { moment in
            ((value - rangeInterval)...(value + rangeInterval)).contains(moment)
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
                guard oldMarker.position != object.position else {
                    continue
                }

                let oldConstraint = oldMarker.constraint
                let newConstraint = oldConstraint.constraintWithMultiplier(min(max(minPossibleMultiplier, centerXOfView * CGFloat(object.position)), maxPossibleMultiplier))
                // Set to low to avoid messing with the slider layout if at the edges
                newConstraint.priority = .defaultLow

                oldConstraint.isActive = false
                newConstraint.isActive = true

                self.markers[object.marker.id] = (markerView: oldMarker.markerView, position: object.position, constraint: newConstraint)
            } else {
                let markerView = UIView()
                markerView.isUserInteractionEnabled = false
                markerView.translatesAutoresizingMaskIntoConstraints = false
                markerView.backgroundColor = object.marker.markerColor
                addSubview(markerView)
                #if os(tvOS)
                markerView.widthAnchor.constraint(equalToConstant: 4).isActive = true
                markerView.heightAnchor.constraint(equalToConstant: 10).isActive = true
                #else
                markerView.widthAnchor.constraint(equalToConstant: 2).isActive = true
                markerView.heightAnchor.constraint(equalToConstant: 6).isActive = true
                #endif
                markerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

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

                self.markers[object.marker.id] = (markerView: markerView, position: object.position, constraint: constraint)
            }
        }

        bringSubviewToFront(thumbView)

        layoutIfNeeded()
    }
}
