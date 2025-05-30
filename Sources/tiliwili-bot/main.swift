import Vapor
import Logging
import NIOCore
import NIOPosix

#if canImport(Darwin)
import Foundation
import Darwin // Apple platforms
#elseif canImport(Glibc)
@preconcurrency import Glibc // GlibC Linux platforms
//setbuf(stdout, nil) // disable buffer for stdout prints
#elseif canImport(CRT)
import Foundation
import CRT // Windows platforms
#endif


private var env = try Environment.detect()
try LoggingSystem.bootstrap(from: &env)
private let eventLoop: EventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount == 1 ? System.coreCount * 2 : System.coreCount)
let app: Application = try await Application.make(env, Application.EventLoopGroupProvider.shared(eventLoop))
app.logger = setupLogger(label: "Tiliwili", level: .debug)
// This attempts to install NIO as the Swift Concurrency global executor.
// You should not call any async functions before this point.
private let executorTakeoverSuccess = NIOSingletons.unsafeTryInstallSingletonPosixEventLoopGroupAsConcurrencyGlobalExecutor()
app.logger.debug("Running with \(executorTakeoverSuccess ? "SwiftNIO" : "standard") Swift Concurrency default executor")

do {
    try await configure(app, env)
} catch {
    app.logger.critical("1 - error: \(String(describing: error))\n\(error.localizedDescription)")
    app.logger.critical("2 - error: \(String(reflecting: error))")
    try? await app.asyncShutdown()
}
app.logger.notice("begin app app.execute()...")
try await app.execute()
try await app.asyncShutdown()
