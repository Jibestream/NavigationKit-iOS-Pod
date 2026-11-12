// swift-tools-version:5.9
// Swift Package Manager distribution of the Jibestream NavigationKit, starting at 3.0.0.
// The same git tag also serves the CocoaPods podspec (NavigationKit-iOS-Pod.podspec) until
// CocoaPods is retired.
//
// Release: tag the commit with the bare semantic version (e.g. `3.0.0`, no `v` prefix) and keep
// `s.version` in NavigationKit-iOS-Pod.podspec in step with it.
import PackageDescription

let package = Package(
    name: "NavigationKit-iOS-Pod",
    platforms: [
        // Must be at least the JMapiOSSDK package's own floor, or SPM refuses to resolve the
        // graph. The shipped binary is built for iOS 10 and stays forward-compatible, so this
        // is a policy floor rather than a technical one.
        .iOS(.v15)
    ],
    products: [
        // NavigationKitSPMSupport ships in the same product as the binary target on purpose: see its
        // comment below. A consumer adds this one product and gets both.
        .library(
            name: "JMapNavigationKit",
            targets: ["JMapNavigationKit", "NavigationKitSPMSupport"]
        )
    ],
    dependencies: [
        // A range, not `exact:`. An exact pin here makes the dependency graph
        // unsatisfiable for any consumer that declares its own JMapiOSSDK requirement.
        .package(url: "https://github.com/Jibestream/JMap-iOS-SDK-Pod.git", from: "6.0.0")
    ],
    targets: [
        // Static Objective-C framework containing no Objective-C categories of its own, so it
        // adds no -ObjC requirement beyond the one JMapiOSSDK already imposes.
        //
        // The archive carries no LC_LINKER_OPTION, so it auto-links nothing by itself. Its
        // system frameworks are linked through the consumer's Clang module graph instead: its
        // public headers import CoreLocation, Foundation and UIKit, and JMapRenderingKit's import WebKit.
        // Verified by linking and running an app against all six modules with -ObjC, where
        // CoreLocation and WebKit both end up in the app binary. Hence no linkerSettings here.
        .binaryTarget(
            name: "JMapNavigationKit",
            path: "NavigationKit-iOS-Pod/Frameworks/JMapNavigationKit.xcframework"
        ),
        // Exists only to carry the JMapiOSSDK dependency edge, which `.binaryTarget` cannot
        // declare. JMapNavigationKit's public headers `#import <JMapCoreKit/...>`,
        // `<JMapRenderingKit/...>` and `<JMapControllerKit/...>`, so without this edge
        // `import JMapNavigationKit` fails to compile with "'JMapCoreKit/JMapCoreKit.h' file not found".
        .target(
            name: "NavigationKitSPMSupport",
            dependencies: [.product(name: "JMapiOSSDK", package: "JMap-iOS-SDK-Pod")]
        )
    ]
)
