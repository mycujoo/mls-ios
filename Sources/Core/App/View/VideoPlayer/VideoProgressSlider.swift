//
// Copyright © 2020 mycujoo. All rights reserved.
//

import UIKit

class VideoProgressSlider: UIControl {

    /// Describes how many points the thumb needs to be away from the center of a timeline marker before its bubble appears/disappears.
    #if os(tvOS)
    private let showTimelineMarkerBubbleWithinPointRange: Double = 12.0
    #else
    private let showTimelineMarkerBubbleWithinPointRange: Double = 5.0
    #endif

    //MARK: - Properties
    
    private var _value: Double = 0.0 {
        didSet { updateLayerFrames() }
    }

    #if os(tvOS)
    /// The value of `_value` at the start of a new tracking operation. Is used to determine the starting position of the thumb on tvOS.
    private var valueOnFirstTouch: Double = 0.0

    /// The value between 0 and 1 that marks the first position of the thumb as reported by tvOS.
    /// Typically 0.5, but sometimes a little off on the first call to `continueTracking`, so determine the value there.
    private var initialTrackingOffset: Double = 0.5

    /// A helper boolean to determine if this call to `continueTracking` is the first after `beginTracking` was called.
    private var isFirstContinueAfterBeginTracking = true
    #endif

    /// Marks the seek position of the currently visible marker bubble (if one is on-screen, nil otherwise).
    private var visibleMarkerSeekPosition: Double? = nil

    var value: Double {
        get { mapToOriginalValue(_value)  }
        set {
            guard !isTracking else { return }
            _value = mapFromOriginalValue(newValue)
        }
    }

    /// Set to true when the slider should not produce any updates. This is recommended when the slider has focus, but the TV remote is being tapped/selected.
    var ignoreTracking = false

    /// A helper to set the initial value of the slider. This is needed because the thumbview should be positioned inside of the slider, i.e. at a non-zero initial value.
    private var wasInitialized = false

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

    private lazy var rightConstraintOfTrackView: NSLayoutConstraint = {
        trackView.rightAnchor.constraint(equalTo: leftAnchor)
    }()

    let thumbView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        view.backgroundColor = nil
        view.heightAnchor.constraint(equalToConstant: 30).isActive = true
        view.widthAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        view.isHidden = true
        return view
    }()

    let thumbInnerView: UIView = {
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
        thumbView.centerXAnchor.constraint(equalTo: leftAnchor)
    }()
    
    var thumbTintColor = UIColor.white

    var annotationBubbleColor = UIColor.black
    
    override var frame: CGRect {
        didSet {
            updateLayerFrames()
        }
    }

    private let markerBubbleLabel: UILabel = {
        #if os(tvOS)
        let label = PaddingLabel(padding: UIEdgeInsets.init(top: 6, left: 12, bottom: 6, right: 12))
        #else
        let label = PaddingLabel(padding: UIEdgeInsets.init(top: 4, left: 8, bottom: 4, right: 8))
        #endif
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = false
        label.numberOfLines = 10
        label.lineBreakMode = .byWordWrapping
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.75
        #if os(tvOS)
        label.font = UIFont.systemFont(ofSize: 22, weight: .regular)
        label.layer.cornerRadius = 12
        #else
        label.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        label.layer.cornerRadius = 3
        #endif
        label.textAlignment = .center
        label.clipsToBounds = true
        label.alpha = 0.0
        return label
    }()

    private var centerXConstraintOfMarkerBubble: NSLayoutConstraint? = nil

    /// A dictionary of marker ids (keys) to tuples (values). Each tuple contains:
    /// * the TimelineMarker object itself
    /// * a UIView that represents the timeline marker
    /// * a position (between 0 and 1) that describes its relative position on the seekbar
    /// * a seek position (between 0 and 1) that describes its relative position on the seekbar  that it should seek to when selected
    /// * a constraint that is used to set its position. This could be derived from the markerView's layoutAnchors but its quicker to access this way.
    private var markers: [String: (marker: TimelineMarker, markerView: UIView, position: Double, seekPosition: Double, constraint: NSLayoutConstraint)] = [:]
    
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
                    timeView.leftAnchor.constraint(equalTo: leftAnchor),
                    timeView.rightAnchor.constraint(equalTo: rightAnchor),
                    timeView.centerYAnchor.constraint(equalTo: centerYAnchor)
                ]
        )

        addSubview(trackView)
        NSLayoutConstraint
            .activate(
                [
                    trackView.leftAnchor.constraint(equalTo: leftAnchor),
                    rightConstraintOfTrackView,
                    trackView.centerYAnchor.constraint(equalTo: centerYAnchor)
                ]
        )

        addSubview(thumbView)
        centerXOfThumbView.isActive = true
        thumbView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        thumbView.addSubview(thumbInnerView)
        thumbInnerView.centerXAnchor.constraint(equalTo: thumbView.centerXAnchor).isActive = true
        thumbInnerView.centerYAnchor.constraint(equalTo: thumbView.centerYAnchor).isActive = true

        addSubview(markerBubbleLabel)
        markerBubbleLabel.bottomAnchor.constraint(equalTo: topAnchor, constant: -4).isActive = true
        #if os(tvOS)
        markerBubbleLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 320).isActive = true
        #else
        markerBubbleLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 80).isActive = true
        #endif
    }
    
    private func updateLayerFrames() {
        if bounds.width == 0 || thumbView.bounds.width == 0 {
            // Hide the thumb as long as the bounds are not set. This is needed because the thumbView is initially misplaced (due to the custom mapping).
            thumbView.isHidden = true
        } else {
            if !wasInitialized {
                wasInitialized = true
                // Reset the value, which will be mapped to a non-nil value that considers the thumbView size to be within the bounds of the slider.
                _value = mapFromOriginalValue(0)
                return
            }
            thumbView.isHidden = false
        }
        let thumbCenter = bounds.width * CGFloat(_value)
        rightConstraintOfTrackView.constant = thumbCenter
        centerXOfThumbView.constant = thumbCenter
    }

    //MARK: - Touching
    #if os(tvOS)
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        // Do not consider ignoreTracking here, because if we return false here, `.touchDown` is never fired, which is useful.
        let width = Double(bounds.width)
        guard width > 0 else { return false }

        valueOnFirstTouch = _value

        // Reset `isFirstContinueAfterBeginTracking`.
        isFirstContinueAfterBeginTracking = true

        return true
    }
    #endif

    /// - returns: A mapped value that corrects for the bounds of the thumb view, because we want that to appear fully within the bounds of the slider.
    private func mapFromOriginalValue(_ originalValue: Double) -> Double {
        #if os(iOS)
        let sliderWidth = Double(bounds.width)
        let thumbWidth = Double(thumbInnerView.bounds.width)

        guard sliderWidth > 0 && thumbWidth > 0 else { return originalValue }

        return 0.5 - ((originalValue <= 0.5 ? 1 : -1) * (abs(0.5 - originalValue) * ((sliderWidth - thumbWidth) / sliderWidth)))
        #else
        return originalValue
        #endif
    }

    /// - returns: A mapped value that corrects for the bounds of the thumb view, because we want that to appear fully within the bounds of the slider.
    private func mapToOriginalValue(_ translatedValue: Double) -> Double {
        #if os(iOS)
        let sliderWidth = Double(bounds.width)
        let thumbWidth = Double(thumbInnerView.bounds.width)

        guard sliderWidth > 0 && thumbWidth > 0 else { return translatedValue }

        return 0.5 - ((translatedValue <= 0.5 ? 1 : -1) * (abs(0.5 - translatedValue) / ((sliderWidth - thumbWidth) / sliderWidth)))
        #else
        return translatedValue
        #endif
    }

    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        guard !ignoreTracking else { return false }

        let width = Double(bounds.width)
        guard width > 0 else { return false }

        /// This is the naive value of the slider. It does not take into consideration the bounds of the thumb view, since we want those to appear fully within the bounds of the slider.
        let originalV = max(0, min(Double(touch.location(in: self).x), width)) / width

        #if os(tvOS)
        if isFirstContinueAfterBeginTracking {
            isFirstContinueAfterBeginTracking = false
            initialTrackingOffset = originalV
        }

        // Calculate the position relative to the starting position for a smoother seeking experience.
        // This formula is needed because every new tracking operation starts with a touch location
        // in the center of the seekbar.
        
        var vTranslated = (originalV - initialTrackingOffset)
        if initialTrackingOffset > 0.5 {
            if vTranslated > 0.0 {
                vTranslated = vTranslated * (0.5 / (1 - initialTrackingOffset))
            } else {
                vTranslated = vTranslated / (0.5 / (1 - initialTrackingOffset))
            }
        } else {
            if vTranslated > 0.0 {
                vTranslated = vTranslated / (0.5 / initialTrackingOffset)
            } else {
                vTranslated = vTranslated * (0.5 / initialTrackingOffset)
            }
        }

        // Divide by 6 means that a user needs at most 12 swipes to cross the entire seekbar from start to finish.
        _value = max(0, min(1, vTranslated / 6 + valueOnFirstTouch))

        #else
        _value = mapFromOriginalValue(originalV)
        #endif

        let rangeInterval = showTimelineMarkerBubbleWithinPointRange / width
        // TODO: Don't get the first, but get the closest.
        if let marker = (markers.first { ((value - rangeInterval)...(value + rangeInterval)).contains($0.value.position) }) {
            markerBubbleLabel.backgroundColor = annotationBubbleColor
            markerBubbleLabel.textColor = annotationBubbleColor.isDarkColor ? .white : .black
            markerBubbleLabel.text = marker.value.marker.label

            if let constraint = centerXConstraintOfMarkerBubble, let secondItem = constraint.secondItem, secondItem.isEqual(marker.value.markerView) {} else {
                // There is either no constraint for the marker bubble yet, or it is currently placed on a different timeline marker.
                // (Re)place it with a new constraint.
                centerXConstraintOfMarkerBubble?.isActive = false
                centerXConstraintOfMarkerBubble = markerBubbleLabel.centerXAnchor.constraint(equalTo: marker.value.markerView.centerXAnchor)
                centerXConstraintOfMarkerBubble?.priority = .defaultLow
                centerXConstraintOfMarkerBubble?.isActive = true
            }
            if markerBubbleLabel.alpha < 1 {
                UIView.animate(withDuration: 0.15) { [weak self] in
                    self?.markerBubbleLabel.alpha = 1.0
                }
            }
            visibleMarkerSeekPosition = marker.value.seekPosition
        } else {
            if markerBubbleLabel.alpha > 0 {
                UIView.animate(withDuration: 0.15) { [weak self] in
                    self?.markerBubbleLabel.alpha = 0.0
                }
            }
            visibleMarkerSeekPosition = nil
        }

        sendActions(for: .valueChanged)

        return true
    }

    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        UIView.animate(withDuration: 0.15) { [weak self] in
            self?.markerBubbleLabel.alpha = 0.0
        }

        if !ignoreTracking {
            if let visibleMarkerSeekPosition = visibleMarkerSeekPosition {
                // Stick to the marker that is currently on-screen.
                _value = mapFromOriginalValue(visibleMarkerSeekPosition)

                sendActions(for: .valueChanged)
            }
        }

        super.endTracking(touch, with: event)
    }
}

extension VideoProgressSlider {
    func setTimelineMarkers(with operations: [MLSUI.ShowTimelineMarkerAction]) {
        guard !isTracking else {
            // Tracking the slider while rebuilding timeline markers causes the occassional crash because it tries to
            // reference an unowned unsafe secondItem. To avoid this (as well as avoiding markers that keep moving),
            // keep the markers static while tracking.
            // In the future, it may be good to retrigger this method when the tracking is done, but let's keep it simple for now.
            return
        }

        /// Takes a position (value between 0 and 1) and returns a multiplier that can be used on a centerXAnchor for the timeline marker.
        func calcConstraintMultiplier(position: Double) -> CGFloat {
            let minPossibleMultiplier: CGFloat = 0.001
            let maxPossibleMultiplier: CGFloat = 2
            let centerXOfView: CGFloat = 2

            return min(max(minPossibleMultiplier, centerXOfView * CGFloat(mapFromOriginalValue(position))), maxPossibleMultiplier)
        }

        // Remove markers that are not relevant anymore.
        let newMarkerIds = operations.map { $0.actionId }
        for oldMarker in self.markers {
            if !newMarkerIds.contains(oldMarker.key) {
                oldMarker.value.markerView.removeFromSuperview()
                self.markers[oldMarker.key] = nil
            }
        }

        for operation in operations {
            if let oldMarker = self.markers[operation.actionId] {
                guard oldMarker.position != operation.position else {
                    continue
                }

                let oldConstraint = oldMarker.constraint
                let newConstraint = oldConstraint.constraintWithMultiplier(calcConstraintMultiplier(position: operation.position))
                // Set to low to avoid messing with the slider layout if at the edges
                newConstraint.priority = .defaultLow

                oldConstraint.isActive = false
                newConstraint.isActive = true

                self.markers[operation.actionId] = (marker: operation.timelineMarker, markerView: oldMarker.markerView, position: operation.position, seekPosition: operation.seekPosition, constraint: newConstraint)
            } else {
                let markerView = UIView()
                markerView.isUserInteractionEnabled = false
                markerView.translatesAutoresizingMaskIntoConstraints = false
                markerView.backgroundColor = operation.timelineMarker.color
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
                    multiplier: calcConstraintMultiplier(position: operation.position),
                    constant: 0
                )
                // Set to low to avoid messing with the slider layout if at the edges
                constraint.priority = .defaultLow
                constraint.isActive = true

                self.markers[operation.actionId] = (marker: operation.timelineMarker, markerView: markerView, position: operation.position, seekPosition: operation.seekPosition, constraint: constraint)
            }
        }

        bringSubviewToFront(thumbView)

        layoutIfNeeded()
    }
}
