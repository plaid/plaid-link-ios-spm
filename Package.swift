// swift-tools-version:5.7
import PackageDescription

/// A precompiled XCFramework of the plaid-link-ios repo that was compiled with Xcode 16.1.0
/// This XCFramework can be used by Xcode 16.1.0 and later.
let linkKitXCFramework = Target.binaryTarget(
  name: "LinkKit",
  url: "https://github.com/plaid/plaid-link-ios/releases/download/6.4.2/LinkKit.xcframework.zip",
  checksum: "e7250f04ccd2f0ea72ba3b612d6e7a11acba9245f60b683d781a341b2fd8ce72"
)

let package = Package(
  name: "LinkKit",
  platforms: [.iOS(.v14)],
  products: [.library(name: "LinkKit", targets: ["LinkKit", "LinkKitSub"])],
  targets: [
    linkKitXCFramework,

    // Without at least one regular (non-binary) target, this package doesn't show up
    // in Xcode under "Frameworks, Libraries, and Embedded Content". That prevents
    // LinkKit from being embedded in the app product, causing the app to crash when
    // ran on a physical device. As a workaround, we can include a stub target
    // with at least one source file.
    // https://github.com/apple/swift-package-manager/issues/6069
    .target(name: "LinkKitSub", path: "Sources", resources: [.copy("Resources/PrivacyInfo.xcprivacy")]),
  ]
)
