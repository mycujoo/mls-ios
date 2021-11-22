This SDK is intended for customers of MyCujoo Live Services. It offers a video player, overlays, analytics and more. It currently supports iOS and tvOS.

## Installation

### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate our SDK into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'MLSSDK', :git => 'https://github.com/Mycujoo/mls-ios.git', :branch => 'master'
```

And if you want to use the various extensions, use one (or more) of the following:

```ruby
pod 'MLSSDK/Annotations', :git => 'https://github.com/Mycujoo/mls-ios.git', :branch => 'master'
pod 'MLSSDK/IMA', :git => 'https://github.com/Mycujoo/mls-ios.git', :branch => 'master'
pod 'MLSSDK/Cast', :git => 'https://github.com/Mycujoo/mls-ios.git', :branch => 'master'
```

### Swift package manager (experimental, not feature-complete!)

If you want to install our SDK via the Xcode UI, go to your Project Settings -> Swift Packages and add MLSSDK from there.

To integrate using Apple's Swift package manager, without Xcode integration, add the following as a dependency to your `Package.swift`:

```
.package(url: "https://github.com/MyCujoo/mls-ios.git", .upToNextMajor(from: "1.3"))
```

**Important: unfortunately, by installing MLSSDK via SPM will lead to a reduced feature-set, as not all dependencies are supported through SPM yet. You will miss out on IMA (monetization), Chromecast, and Youbora (video analytics).**

## Usage

For any interaction with our SDK, you will first need to instantiate an `MLS` object. This requires a public key (which can be obtained through the MLS console at https://mls.mycujoo.tv), and a configuration. You will need to retain a strong reference to this `MLS` object while using any of its components. 

### Video player

To render a basic video player, you must:

1. instantiate a `VideoPlayer` object. This can be done via the `videoPlayer(with: Event?)` method on your `MLS` object. Keep in mind that each new call to this method instantiates a new object.
2. Place the `VideoPlayer`'s `playerView` property within your app's view hierarchy.
3. Load an `Event` object into the video player (which represents an event that you have previously created through the MLS Console or the MLS API). To obtain an `Event` object, you can use the `dataProvider` on your `MLS` object. This `dataProvider` connects to the MLS API to obtain a single event (by id) or a list of events.

#### Airplay

Airplay is included in the core component, and works by default. However, to ensure that Airplay continues to operate while your app is moved to the background by your user, a few things need to happen on your side:

- Add the "Background Modes -> Audio, Airplay, and Picture in Picture" capability to your application.
- Ensure that the following is added to your Info.plist (Xcode may do this automatically if you add the background mode):

```
<key>UIBackgroundModes</key>
<array>
    <string>audio</string>
</array>
```

### IMA

To use the IMA extension, please ensure the following:

- Include the `MLSSDK/IMA` pod in your Podfile (see Installation).
- Provide an `imaAdUnit` to the SDK through the MCLS Console or API, or through code (see Examples section). For now, only one ad unit can be provided globally. For specific targetting, custom parameters can be provided on a per-event basis.
- Set the `imaIntegration` property on the VideoPlayer (before using it), and provide a delegate. See Examples.

Also, make sure to follow the guidelines as laid out here: https://developers.google.com/interactive-media-ads/docs/sdks/ios/client-side/ios14

### Chromecast

To use the Chromecast extension, please ensure the following:

- Include the `MLSSDK/Cast` pod in your Podfile (see Installation).
- Change your application's `Info.plist` file in accordance with Google's instructions as outlined on this page: https://developers.google.com/cast/docs/ios_sender. For the "appId" you should use `4381F502`. This app uses the Bluetooth-supported version of the cast SDK, so ensure you add the `Privacy - Bluetooth Always Usage Description` key.
- Add the "Access WiFi information" capability to your application. 
- Set the `castIntegration` property on the VideoPlayer (before using it), and provide a delegate. See Examples.


## Examples

For example code, see the `Examples` folder. The most straightforward example can be found in `SimpleViewController.swift`.

Known issue: in the sample workspace, after running `pod install` and executing the code, the frameworks are being double-linked. This should not impact the examples themselves.
