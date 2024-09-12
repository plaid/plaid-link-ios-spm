// swift-tools-version:5.7
import PackageDescription

/// A precompiled XCFramework of the plaid-link-ios repo that was compiled with Xcode 15.0.1
/// This XCFramework can be used by Xcode 15.0.1 and later.
let linkKitXCFramework = Target.binaryTarget(
  name: "LinkKit",
  url: "https://github.com/plaid/plaid-link-ios/releases/download/5.6.1/LinkKit.xcframework.zip",
  checksum: "a5f547b0ae69875f1e1ef3c56754ba432cf9c15afef0a4dc06ef85ba957d08b5"
)

let package = Package(
  name: "LinkKit",
  platforms: [.iOS(.v14)],
  products: [.library(name: "LinkKit", targets: ["LinkKit", "LinkKitSub"])],
  targets: [
    linkKitXCFramework,

    // Without at least one regular (non-binary) target, this package doesn't show up
    // in Xcode under "Frameworks, Libraries, and Embedded Content". That prevents
    // Lottie from being embedded in the app product, causing the app to crash when
    // ran on a physical device. As a workaround, we can include a stub target
    // with at least one source file.
    // https://github.com/apple/swift-package-manager/issues/6069
    .target(name: "LinkKitSub", path: "Sources", resources: [.copy("Resources/PrivacyInfo.xcprivacy")]),
  ]
)
