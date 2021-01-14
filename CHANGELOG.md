# Change Log
All notable changes to this project will be documented in this file.
`MLSSDK` adheres to [Semantic Versioning](https://semver.org/).

## [1.2.0](https://github.com/MyCujoo/mls-ios/releases/tag/1.2.0)
Released on 2020-01-14.

#### Added
- Added alpha support for Chromecast
- Added alpha support for Apple Airplay
- Added alpha support for IMA preroll support for iOS and tvOS
- Added a Roboto Mono font for overlays
- Added a `localAnnotationActions` property on the VideoPlayer for on-the-fly injection of annotation actions (advanced feature).

#### Changed
- Changed access control for AnnotationAction-related entities to public.
- Renamed `PlayerDelegate` to `VideoPlayerDelegate`

#### Fixed
- Fixed an issue with timer rendering on the overlays
- Fixed a memory leak in the annotation overlay rendering process
- Fixed the AVPlayerNetworkInterceptor's behavior for relative path `.ts` files.

## [1.1.8](https://github.com/MyCujoo/mls-ios/releases/tag/1.1.8)
Released on 2020-12-18.

#### Added
- A new annotation action (`reshow_overlay`) that makes it easier to show overlays after having hid them.


## [1.1.7](https://github.com/MyCujoo/mls-ios/releases/tag/1.1.7)
Released on 2020-11-28.

#### Added
- The possibility of loading custom Events into the VideoPlayer. This can be used to play non-MCLS content in the VideoPlayer (not recommended, as it loses compatibility with other MCLS features, like annotations).
- Added errors to the VideoPlayer to clarify why certain streams are unplayable by the user (e.g. due to geoblocking).
- Added a `l10nBundle` parameter to the `Configuration` object. This can be used to provide a custom `Bundle` from which localized strings should be taken. Useful in advanced scenarios, e.g. when custom error messages should be shown, or support for non-supported languages should be added.

#### Changed
- Expose the `PlayerConfig` object directly on the VideoPlayer, so that it may be altered on the fly.

#### Fixed
- Fixed memory leak (URLProtocol instances were being retained for too long)

## [1.1.6](https://github.com/MyCujoo/mls-ios/releases/tag/1.1.6)
Released on 2020-11-21.

#### Fixed
- Layout constraints on `topLeadingControlsStackView` and `topTrailingControlsStackView`

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
