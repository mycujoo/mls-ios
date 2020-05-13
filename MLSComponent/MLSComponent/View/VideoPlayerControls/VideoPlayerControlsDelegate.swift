//
// Copyright © 2020 mycujoo. All rights reserved.
//

protocol VideoPlayerControlsDelegate: class {
    func playButtonTapped()
    func timeSliderSlide(withValue value: Double)
    func fullscreenButtonTapped()
}
