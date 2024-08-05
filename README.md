# Plaid Link iOS for Swift Package Manager

[![version][link-sdk-version]][link-sdk-pod-url] [![swift compatibility][link-sdk-swift-compat]][link-sdk-spi-url]

This repo provides Swift Package Manager support for [plaid-link-ios](https://github.com/plaid/plaid-link-ios). 

### Installing Plaid Link

To install Plaid Link using [Swift Package Manager](https://github.com/apple/swift-package-manager) you can follow the [tutorial published by Apple](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app) using the URL for this repo with the current version:

1. In Xcode, select “File” → “Add Packages...”
1. Enter https://github.com/plaid/plaid-link-ios-spm.git

or you can add the following dependency to your `Package.swift`:

```swift
.package(url: "https://github.com/plaid/plaid-link-ios-spm.git", from: "5.6.0")
```

### Why is there a separate repo for Swift Package Manager support?

The main git repository for [plaid-link-ios](https://github.com/plaid/plaid-link-ios) is very large (~1 GB), and Swift Package Manager always downloads the full repository with all git history. This [plaid-link-ios-spm](https://github.com/plaid/plaid-link-ios-spm) repo is much smaller (less than 500kb), so can be downloaded much more quickly.

Instead of downloading the full git history of Plaid Link iOS and building it from source, this repo just contains a pointer to the precompiled XCFramework included in the [latest plaid-link-ios release](https://github.com/plaid/plaid-link-ios/releases/latest) (typically ~20MB). Since [plaid-link-ios](https://github.com/plaid/plaid-link-ios) doesn't provide source code it's strongly recommended that user's depend on [plaid-link-ios-spm](https://github.com/plaid/plaid-link-ios-spm) instead.

When using plaid-link-ios-spm, the downloaded `LinkKit.xframework` isn't visible in the project navigator. To validate the authenticity of a plaid-link-ios-spm package, you can confirm that the `Package.swift` file references a binary XCFramework from https://github.com/plaid/plaid-link-ios/releases. 

## Additional Support

📱 The [plaid-link-ios](https://github.com/plaid/plaid-link-ios) repository contains multiple sample applications (requiring Xcode 14) that demonstrate integration and use of Plaid Link for iOS.
* [Swift+UIKit](https://github.com/plaid/plaid-link-ios/tree/master/LinkDemo-Swift)
* [Swift+SwiftUI](https://github.com/plaid/plaid-link-ios/tree/master/LinkDemo-SwiftUI)
* [Objective-C](https://github.com/plaid/plaid-link-ios/tree/master/LinkDemo-ObjC)

📚 Detailed instructions on how to integrate with Plaid Link for iOS can be found in our main documentation at [plaid.com/docs/link/ios][link-ios-docs]. 


[link-ios-docs]: https://plaid.com/docs/link/ios
[link-sdk-version]: https://img.shields.io/cocoapods/v/Plaid
[link-sdk-pod-url]: https://cocoapods.org/pods/Plaid
[link-sdk-spi-url]: https://swiftpackageindex.com/plaid/plaid-link-ios
[link-sdk-swift-compat]: https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fplaid%2Fplaid-link-ios%2Fbadge%3Ftype%3Dswift-versions
