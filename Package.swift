// swift-tools-version:5.7
import PackageDescription

/// A precompiled XCFramework of the plaid-link-ios repo that was compiled with Xcode 15.0.1
/// This XCFramework can be used by Xcode 15.0.1 and later.
let linkKitXCFramework = Target.binaryTarget(
  name: "LinkKit",
  url: "https://github.com/plaid/plaid-link-ios/releases/download/5.6.0/LinkKit.xcframework.zip",
  checksum: "8603d2348d275811dccafa6235f7aab0233ca54a2ee63eec80dfa6de34de72be"
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
