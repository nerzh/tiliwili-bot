// swift-tools-version:5.8

import PackageDescription

let name: String = "tiliwili-bot"

var packageDependencies: [Package.Dependency] = [
    .package(url: "https://github.com/vapor/vapor.git", .upToNextMajor(from: "4.57.0")),
    .package(url: "https://github.com/nerzh/VaporBridges.git", branch: "master"),
    .package(url: "https://github.com/nerzh/PostgresBridge.git", branch: "master"),
    .package(url: "https://github.com/nerzh/swift-regular-expression.git", .upToNextMajor(from: "0.2.3")),
    .package(url: "https://github.com/nerzh/swift-extensions-pack.git", .upToNextMajor(from: "1.2.0")),
]

var mainTarget: [Target.Dependency] = [
    .product(name: "Vapor", package: "vapor"),
    .product(name: "PostgresBridge", package: "PostgresBridge"),
    .product(name: "VaporBridges", package: "VaporBridges"),
    .product(name: "SwiftRegularExpression", package: "swift-regular-expression"),
    .product(name: "SwiftExtensionsPack", package: "swift-extensions-pack"),
]

#if os(Linux)
packageDependencies.append(.package(url: "https://github.com/nerzh/telegram-vapor-bot.git", .upToNextMajor(from: "2.0.1")))
mainTarget.append(.product(name: "TelegramVaporBot", package: "telegram-vapor-bot"))

packageDependencies.append(.package(url: "https://github.com/nerzh/Bridges.git", branch: "master"))
mainTarget.append(.product(name: "Bridges", package: "Bridges"))

packageDependencies.append(.package(url: "https://github.com/nerzh/SwifQL.git", branch: "master"))
mainTarget.append(.product(name: "SwifQL", package: "SwifQL"))
#else
packageDependencies.append(.package(path: "/Users/nerzh/mydata/swift_projects/TelegramVaporBot"))
mainTarget.append(.product(name: "TelegramVaporBot", package: "TelegramVaporBot"))

packageDependencies.append(.package(path: "/Users/nerzh/mydata/swift_projects/Bridges"))
mainTarget.append(.product(name: "Bridges", package: "Bridges"))

packageDependencies.append(.package(path: "/Users/nerzh/mydata/swift_projects/SwifQL"))
mainTarget.append(.product(name: "SwifQL", package: "SwifQL"))
#endif




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
        .executableTarget(
            name: name,
            dependencies: mainTarget,
            swiftSettings: [
                .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release))
            ]
        )
    ]
)


