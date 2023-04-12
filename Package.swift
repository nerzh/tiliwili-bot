// swift-tools-version:5.8

import PackageDescription

let name: String = "tiliwili-bot"

var packageDependencies: [Package.Dependency] = [
    .package(url: "https://github.com/vapor/vapor.git", .upToNextMajor(from: "4.57.0")),
    .package(url: "https://github.com/nerzh/VaporBridges.git", branch: "master"),
    .package(url: "https://github.com/nerzh/PostgresBridge.git", branch: "master"),
    .package(url: "https://github.com/nerzh/Bridges.git", branch: "master"),
    .package(url: "https://github.com/nerzh/swift-regular-expression.git", .upToNextMajor(from: "0.2.3")),
    .package(url: "https://github.com/nerzh/swift-extensions-pack.git", .upToNextMajor(from: "1.2.0")),
    .package(url: "https://github.com/nerzh/telegram-vapor-bot.git", .upToNextMajor(from: "2.0.1")),
]
//
//#if os(Linux)
//    packageDependencies.append(.package(url: "https://github.com/nerzh/telegram-vapor-bot", .upToNextMajor(from: "2.0.1")))
//#else
//    packageDependencies.append(.package(name: "telegram-vapor-bot", path: "/Users/nerzh/mydata/swift_projects/TelegramVaporBot"))
//#endif

let mainTarget: [Target.Dependency] = [
    .product(name: "Vapor", package: "vapor"),
    .product(name: "PostgresBridge", package: "PostgresBridge"),
    .product(name: "VaporBridges", package: "VaporBridges"),
    .product(name: "Bridges", package: "Bridges"),
    .product(name: "TelegramVaporBot", package: "telegram-vapor-bot"),
    .product(name: "SwiftRegularExpression", package: "swift-regular-expression"),
    .product(name: "SwiftExtensionsPack", package: "swift-extensions-pack"),
]

let package = Package(
    name: name,
    platforms: [
       .macOS(.v12)
    ],
    products: [
        .executable(name: name, targets: [name])
    ],
    dependencies: packageDependencies,
    targets: [
        .target(
            name: name,
            dependencies: mainTarget,
            swiftSettings: [
                .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release))
            ]
        )
    ]
)


