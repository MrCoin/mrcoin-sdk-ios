# MrCoin iOS SDK #

## Overview ##

…

## License ##

…

## Technical requirements ##

- iOS 7.0 as a deployment target
- iOS 8.0 SDK to build
- The framework uses automatic reference counting (ARC).

## Adding the static library to your iOS project ##

Note: if you want to use this in a Swift project, you need to use the steps in the "Adding this as a framework" section instead of the following. Swift needs modules for third-party code.

Once you have the latest source code for the framework, it's fairly straightforward to add it to your application. Start by dragging the **MrCoin iOS SDK.xcodeproj** file into your application's Xcode project to embed the framework in your project. Next, go to your application's target and add **MrCoin** as a Target Dependency. Finally, you'll want to drag the **libMrCoin.a** library from the MrCoin SDK framework's Products folder to the Link Binary With Libraries build phase in your application's target.

To use the MrCoin classes within your application, simply include the core framework header using the following:

    #import "MrCoin.h"

Additionally, this is an ARC-enabled framework, so if you want to use this within a manual reference counted application targeting iOS 4.x, you'll need to add -fobjc-arc to your Other Linker Flags as well.

### Building a static library at the command line ###

If you don't want to include the project as a dependency in your application's Xcode project, you can build a universal static library for the iOS Simulator or device. To do this, run `build.sh` at the command line. The resulting library and header files will be located at `build/Release-iphone`. You may also change the version of the iOS SDK by changing the `IOSSDK_VER` variable in `build.sh` (all available versions can be found using `xcodebuild -showsdks`).

## Adding this as a framework (module) to your Mac or iOS project ##

Xcode 6 and iOS 8 support the use of full frameworks, as does the Mac, which simplifies the process of adding this to your application. To add this to your application, I recommend dragging the .xcodeproj project file into your application's project (as you would in the static library target).

For your application, go to its target build settings and choose the Build Phases tab. Under the Target Dependencies grouping, add MrCoinFramework on iOS (not MrCoinSDK, which builds the static library)

This should cause MrCoin to build as a framework. Under Xcode 6, this will also build as a module, which will allow you to use this in Swift projects. When set up as above, you should just need to use 

    import MrCoin

to pull it in.


