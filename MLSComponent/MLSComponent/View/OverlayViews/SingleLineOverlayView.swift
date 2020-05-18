//
// Copyright © 2020 mycujoo. All rights reserved.
//

import UIKit

class SingleLineOverlayView: UIView {

    // MARK: - UI Components

    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Life Cycle

    init() {
        super.init(frame: .zero)
        addSubview(label)
        label.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: topAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Data Driven
extension SingleLineOverlayView {
    struct ViewState: Equatable {
        let title: String
    }

    func render(state: ViewState) {
        label.text = state.title
    }
}
