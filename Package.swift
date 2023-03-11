// swift-tools-version:5.5

import PackageDescription

var packageDependencies: [Package.Dependency] = [
    .package(name: "vapor", url: "https://github.com/vapor/vapor.git", .upToNextMajor(from: "4.57.0")),
//    .package(name: "PostgresBridge", url: "https://github.com/SwifQL/PostgresBridge.git", .upToNextMajor(from:"1.0.0-rc")),
//    .package(name: "VaporBridges", url: "https://github.com/SwifQL/VaporBridges.git", .upToNextMajor(from: "1.0.0-rc")),
//    .package(name: "Bridges", url: "https://github.com/SwifQL/Bridges.git", .upToNextMajor(from: "1.0.0-rc.4.13.1")),
    .package(name: "SwiftRegularExpression", url: "https://github.com/nerzh/swift-regular-expression.git", .upToNextMajor(from: "0.2.3")),
//    .package(name: "swift-crypto", url: "https://github.com/apple/swift-crypto", .upToNextMajor(from: "1.1.6")),
]

#if os(Linux)
    packageDependencies.append(.package(name: "TelegramVaporBot", url: "https://github.com/nerzh/telegram-vapor-bot", .upToNextMajor(from: "2.0.1")))
//    packageDependencies.append(.package(name: "SwiftTonTool", url: "https://github.com/oberton/swift-ton-tool", .upToNextMajor(from: "0.0.1")))
#else
    packageDependencies.append(.package(name: "TelegramVaporBot", path: "/Users/nerzh/mydata/swift_projects/TelegramVaporBot"))
//    packageDependencies.append(.package(name: "SwiftTonTool", path: "/Users/nerzh/mydata/swift_projects/SwiftTonTool"))
#endif



let package = Package(
    name: "tg-bot-as-bot",
    platforms: [
       .macOS(.v12)
    ],
    dependencies: packageDependencies,
    targets: [
        .target(
            name: "tg-bot-as-bot",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
//                .product(name: "PostgresBridge", package: "PostgresBridge"),
//                .product(name: "VaporBridges", package: "VaporBridges"),
//                .product(name: "Bridges", package: "Bridges"),
                .product(name: "TelegramVaporBot", package: "TelegramVaporBot"),
                .product(name: "SwiftRegularExpression", package: "SwiftRegularExpression"),
//                .product(name: "SwiftTonTool", package: "SwiftTonTool"),
            ],
            swiftSettings: [
                // Enable better optimizations when building in Release configuration. Despite the use of
                // the `.unsafeFlags` construct required by SwiftPM, this flag is recommended for Release
                // builds. See <https://github.com/swift-server/guides#building-for-production> for details.
//                .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release))
            ]
        )
        
    ]
)


