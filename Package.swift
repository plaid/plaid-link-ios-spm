// swift-tools-version:5.7
import PackageDescription

/// A precompiled XCFramework of the plaid-link-ios repo that was compiled with Xcode 16.1.0
/// This XCFramework can be used by Xcode 16.1.0 and later.
let linkKitXCFramework = Target.binaryTarget(
  name: "LinkKit",
  url: "https://github.com/plaid/plaid-link-ios/releases/download/6.0.4/LinkKit.xcframework.zip",
  checksum: "65a9d920c80c2331bb132d12044ff33bb9d155e0d7094a7563dc216bf2a1dfda"
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
