# Change Log
All notable changes to this project will be documented in this file.
`MLSSDK` adheres to [Semantic Versioning](https://semver.org/).

## [1.1.5](https://github.com/MyCujoo/mls-ios/releases/tag/1.1.5)
Released on 2020-11-21.

#### Changed
- Removed `topControlsStackView` in favor of  `topLeadingControlsStackView` and `topTrailingControlsStackView`

## [1.1.4](https://github.com/MyCujoo/mls-ios/releases/tag/1.1.4)
Released on 2020-11-17.

#### Fixed
- Memory leak due to a retain cycle

## [1.1.3](https://github.com/MyCujoo/mls-ios/releases/tag/1.1.3)
Released on 2020-11-16.

#### Added
- Added Equatable conformance to Event and Stream definitions
- Downgraded to Starscream 3.x for better compatibility with common libraries (E.g. apollo-ios)

#### Changed
- Code cleanup

## [1.1.2](https://github.com/MyCujoo/mls-ios/releases/tag/1.1.2)
Released on 2020-10-21.

#### Added
- Documentation for installation Swift Package Manager

#### Changed
- Code cleanup

## [1.1.1](https://github.com/MyCujoo/mls-ios/releases/tag/1.1.1)
Released on 2020-10-21.

#### Added
- Introduced an installation method for Swift Package Manager

#### Changed
- Changed base API path.


## [1.1.0](https://github.com/MyCujoo/mls-ios/releases/tag/1.1.0)
Released on 2020-10-05.

#### Added
- Overlays (through the MLS annotation system)
- Added more player configuration options, notably to hide all controls in their entirety.
- Added seek method.
- Introduced changelog

## [1.0.3](https://github.com/MyCujoo/mls-ios/releases/tag/1.0.3)
Released on 2020-09-25.

#### Added
- Timeline markers (through the MLS annotation system)
- Added more player configuration options, notably to show or hide individual UI components within the player.

## [1.0.2](https://github.com/MyCujoo/mls-ios/releases/tag/1.0.2)
Released on 2020-09-18.

#### Fixed
- Xcode 12 compatibility

## [1.0.1](https://github.com/MyCujoo/mls-ios/releases/tag/1.0.1)
Released on 2020-09-14.

#### Added
- Initial player configuration options.

## [1.0.0](https://github.com/MyCujoo/mls-ios/releases/tag/1.0.0)
Released on 2020-08-31.

#### Added
- Initial release.
