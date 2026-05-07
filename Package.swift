// swift-tools-version: 6.3.1

import PackageDescription

let package = Package(
    name: "swift-affine-geometry-primitives",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26),
    ],
    products: [
        .library(name: "Affine Geometry Primitives", targets: ["Affine Geometry Primitives"]),
        .library(
            name: "Affine Geometry Primitives Test Support",
            targets: ["Affine Geometry Primitives Test Support"]
        ),
    ],
    dependencies: [
        .package(path: "../swift-affine-primitives"),
        .package(path: "../swift-algebra-linear-primitives"),
        .package(path: "../swift-dimension-primitives"),
        .package(path: "../swift-numeric-primitives"),
        .package(path: "../swift-tagged-primitives"),
    ],
    targets: [
        .target(
            name: "Affine Geometry Primitives",
            dependencies: [
                .product(name: "Affine Primitives", package: "swift-affine-primitives"),
                .product(name: "Algebra Linear Primitives", package: "swift-algebra-linear-primitives"),
                .product(name: "Dimension Primitives", package: "swift-dimension-primitives"),
                .product(name: "Real Primitives", package: "swift-numeric-primitives"),
            ]
        ),
        .target(
            name: "Affine Geometry Primitives Test Support",
            dependencies: [
                "Affine Geometry Primitives",
                .product(name: "Tagged Primitives Test Support", package: "swift-tagged-primitives"),
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Affine Geometry Primitives Tests",
            dependencies: [
                "Affine Geometry Primitives",
                .product(name: "Tagged Primitives Standard Library Integration", package: "swift-tagged-primitives"),
                "Affine Geometry Primitives Test Support",
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("LifetimeDependence"),
        .enableExperimentalFeature("Lifetimes"),
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableUpcomingFeature("LifetimeDependence"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
