// swift-tools-version:6.0

import PackageDescription

var packageDependencies: [Package.Dependency] = []
var targetDependencies: [PackageDescription.Target.Dependency] = []
var targetPlugins: [PackageDescription.Target.PluginUsage] = []


#if os(Linux)
packageDependencies.append(.package(url: "https://github.com/vapor/vapor.git", .upToNextMajor(from: "4.57.0")))
targetDependencies.append(.product(name: "Vapor", package: "vapor"))

packageDependencies.append(.package(url: "https://github.com/vapor/fluent", .upToNextMajor(from: "4.12.0")))
targetDependencies.append(.product(name: "Fluent", package: "fluent"))

packageDependencies.append(.package(url: "https://github.com/vapor/fluent-postgres-driver", .upToNextMajor(from: "2.10.0")))
targetDependencies.append(.product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"))

packageDependencies.append(.package(url: "https://github.com/nerzh/swift-telegram-sdk.git", .upToNextMajor(from: "3.9.2")))
targetDependencies.append(.product(name: "SwiftTelegramSdk", package: "swift-telegram-sdk"))

packageDependencies.append(.package(url: "https://github.com/nerzh/swift-extensions-pack.git", .upToNextMajor(from: "2.0.3")))
targetDependencies.append(.product(name: "SwiftExtensionsPack", package: "swift-extensions-pack"))

packageDependencies.append(.package(url: "https://github.com/nerzh/swift-regular-expression.git", .upToNextMajor(from: "0.2.3")))
targetDependencies.append(.product(name: "SwiftRegularExpression", package: "swift-regular-expression"))

packageDependencies.append(.package(url: "https://github.com/nerzh/swift-custom-logger", .upToNextMajor(from: "1.1.0")))
targetDependencies.append(.product(name: "SwiftCustomLogger", package: "swift-custom-logger"))
#else
packageDependencies.append(.package(url: "https://github.com/vapor/vapor.git", .upToNextMajor(from: "4.57.0")))
targetDependencies.append(.product(name: "Vapor", package: "vapor"))

packageDependencies.append(.package(url: "https://github.com/vapor/fluent", .upToNextMajor(from: "4.12.0")))
targetDependencies.append(.product(name: "Fluent", package: "fluent"))

packageDependencies.append(.package(url: "https://github.com/vapor/fluent-postgres-driver", .upToNextMajor(from: "2.10.0")))
targetDependencies.append(.product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"))

packageDependencies.append(.package(url: "https://github.com/nerzh/swift-telegram-sdk.git", .upToNextMajor(from: "3.9.2")))
targetDependencies.append(.product(name: "SwiftTelegramSdk", package: "swift-telegram-sdk"))

packageDependencies.append(.package(url: "https://github.com/nerzh/swift-extensions-pack.git", .upToNextMajor(from: "2.0.3")))
targetDependencies.append(.product(name: "SwiftExtensionsPack", package: "swift-extensions-pack"))

packageDependencies.append(.package(url: "https://github.com/nerzh/swift-regular-expression.git", .upToNextMajor(from: "0.2.3")))
targetDependencies.append(.product(name: "SwiftRegularExpression", package: "swift-regular-expression"))

packageDependencies.append(.package(url: "https://github.com/nerzh/swift-custom-logger", .upToNextMajor(from: "1.1.0")))
targetDependencies.append(.product(name: "SwiftCustomLogger", package: "swift-custom-logger"))
#endif



let name: String = "tiliwili-bot"
let package = Package(
    name: name,
    platforms: [
       .macOS(.v13)
    ],
    products: [
        .executable(name: name, targets: [name])
    ],
    dependencies: packageDependencies,
    targets: [
        .executableTarget(
            name: name,
            dependencies: targetDependencies,
            path: "Sources/\(name)",
            plugins: targetPlugins
        )
    ]
)


