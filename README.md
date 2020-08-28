This SDK is intended for customers MyCujoo Live Services. It offers a video player, overlays, analytics and more. It currently supports iOS and tvOS.

## Installation

### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate our SDK into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'MLSSDK', '~> 1.0'
```

## Usage

For any interaction with our SDK, you will first need to instantiate an `MLS` object. This requires a public key (which can be obtained through the MLS console at https://mls.mycujoo.tv), and a configuration. You will need to retain a strong reference to this `MLS` object while using any of its components. 

### Video player

To render a basic video player, you must:

1. instantiate a `VideoPlayer` object. This can be done via the `videoPlayer(with: Event?)` method on your `MLS` object. Keep in mind that each new call to this method instantiates a new object.
2. Place the `VideoPlayer`'s `playerView` property within your app's view hierarchy.
3. Load an `Event` object into the video player (which represents an event that you have previously created through the MLS Console or the MLS API). To obtain an `Event` object, you can use the `dataProvider` on your `MLS` object. This `dataProvider` connects to the MLS API to obtain a single event (by id) or a list of events.

## Examples

For example code, see the `Examples` folder. The most straightforward example can be found in `SimpleViewController.swift`.
