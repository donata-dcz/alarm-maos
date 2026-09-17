// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "CocoricoAlarm",
    platforms: [
        .iOS(.v26)
    ],
    targets: [
        .target(
            name: "AlarmCore",
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency"),
            ]
        ),
        /*
        .testTarget(
            name: "AlarmCoreTests",
            dependencies: ["AlarmCore"],
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency"),
            ]
        ),
        */
    ]
)
