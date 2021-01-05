//
// Copyright © 2021 mycujoo. All rights reserved.
//

import Foundation
import UIKit
import MLSSDK
import GoogleCast


public protocol CastIntegrationDelegate: class {
    /// Should be implemented by the SDK user. Should return a UIView to which this SDK can add the Google Cast mini-controller as a subview. Nil if the mini controller is not desired.
    func getMiniControllerParentView() -> UIView?

    /// Should be implemented by the SDK user. Should return a UIView to which this SDK can add the Google Cast button.
    /// - note:  It is recommended that the SDK user places this UIView inside the `topTrailingControlsStackView` UIStackView on the VideoPlayer.
    func getCastButtonParentView() -> UIView
}


public class CastIntegrationFactory {
    public static func build(delegate: CastIntegrationDelegate) -> CastIntegration {
        return CastIntegrationImpl(delegate: delegate)
    }
}

class CastIntegrationImpl: NSObject, CastIntegration, GCKLoggerDelegate {
    weak var delegate: CastIntegrationDelegate?

    lazy var appId: String = {
        guard let appId = Bundle(for: type(of: self)).object(forInfoDictionaryKey: "CastAppId") as? String else {
            fatalError("Could not read Cast appId from Info.plist")
        }
        return appId
    }()

    init(delegate: CastIntegrationDelegate) {
        self.delegate = delegate

        super.init()
    }

    func initialize() {
        guard let delegate = delegate else { return }
        let criteria = GCKDiscoveryCriteria(applicationID: appId)
        let options = GCKCastOptions(discoveryCriteria: criteria)
        GCKCastContext.setSharedInstanceWith(options)

        let castButton = GCKUICastButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        castButton.tintColor = UIColor.gray

        let castButtonParentView = delegate.getCastButtonParentView()
//        castButtonParentView.translatesAutoresizingMaskIntoConstraints = false
        castButtonParentView.addSubview(castButton)
        let castButtonConstraints = [
            castButton.leftAnchor.constraint(equalTo: castButtonParentView.leftAnchor),
            castButton.rightAnchor.constraint(equalTo: castButtonParentView.rightAnchor),
            castButton.topAnchor.constraint(equalTo: castButtonParentView.topAnchor),
            castButton.bottomAnchor.constraint(equalTo: castButtonParentView.bottomAnchor),
        ]
        for constraint in castButtonConstraints {
            constraint.priority = UILayoutPriority(rawValue: 749)
        }
        NSLayoutConstraint.activate(castButtonConstraints)

        #if DEBUG
        GCKLogger.sharedInstance().delegate = self
        #endif
    }
}

// MARK: - GCKLoggerDelegate

extension CastIntegrationImpl {
    func logMessage(_ message: String, at level: GCKLoggerLevel, fromFunction function: String, location: String) {
        print(function + " - " + message)
    }
}
