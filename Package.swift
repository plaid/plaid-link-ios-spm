// swift-tools-version:5.7
import PackageDescription

/// A precompiled XCFramework of the plaid-link-ios repo that was compiled with Xcode 16.1.0
/// This XCFramework can be used by Xcode 16.1.0 and later.
let linkKitXCFramework = Target.binaryTarget(
  name: "LinkKit",
  url: "https://github.com/plaid/plaid-link-ios/releases/download/7.0.1/LinkKit.xcframework.zip",
  checksum: "efbdd7fea163decfdaed3dda8e7a71cc6b79efd55cb974f5ef24d721992bed2b"
)

let package = Package(
  name: "LinkKit",
  platforms: [.iOS(.v15)],
  products: [
    .library(name: "LinkKit", targets: ["LinkKit", "LinkKitSub"]),
    .library(name: "LinkKitObjC", targets: ["LinkKitObjC"]),
  ],
  targets: [
    linkKitXCFramework,
    .target(
      name: "LinkKitObjC",
      dependencies: ["LinkKitObjCInternal", "LinkKit"],
      path: "Sources/ObjC-Support/Swift"
    ),
    .target(
      name: "LinkKitObjCInternal",
      dependencies: ["LinkKit"],
      path: "Sources/ObjC-Support/ObjectiveC",
      publicHeadersPath: "include"
    ),

    // Without at least one regular (non-binary) target, this package doesn't show up
    // in Xcode under "Frameworks, Libraries, and Embedded Content". That prevents
    // LinkKit from being embedded in the app product, causing the app to crash when
    // ran on a physical device. As a workaround, we can include a stub target
    // with at least one source file.
    // https://github.com/apple/swift-package-manager/issues/6069
    .target(name: "LinkKitSub", path: "Sources/LinkKitSub", resources: [.copy("Resources/PrivacyInfo.xcprivacy")]),
    .testTarget(
      name: "LinkKitObjCTests",
      dependencies: ["LinkKit", "LinkKitObjC", "LinkKitObjCInternal"]
    ),
  ]
)
