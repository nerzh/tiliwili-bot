//
//  LogConfig.swift
//  tiliwili-bot
//
//  Created by Oleh Hudeichuk on 30.05.2025.
//

//
// LogConfig.swift
//

import Foundation
import SwiftCustomLogger
import Logging

private let LOG_FORMATTER: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "[MM.dd.yy HH:mm:ss]"
    return formatter
}()

func baseDateFormater() -> DateFormatter {
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone(identifier: "UTC")
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
}


public struct JsonFormatter: LogFormatter {
    public let timestampFormatter: DateFormatter

    public static var timestampFormatter: DateFormatter {
        let fmt = baseDateFormater()
        fmt.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'.000000000Z'"
        return fmt
    }
    
    struct Format: Codable {
        var timestamp: String
        var level: String
        var message: String
        var errorName: String?
        var errorMessage: String?
        var errorTrace: String?
    }
    
    public init(timestampFormatter: DateFormatter = JsonFormatter.timestampFormatter) {
        self.timestampFormatter = timestampFormatter
    }
    
    public func processLog(
        level: Logger.Level,
        message: Logger.Message,
        prettyMetadata: String?,
        file: String,
        function: String,
        line: UInt
    ) -> String {
        let now = Date()
        
        let message = Self.Format.init(
            timestamp: self.timestampFormatter.string(from: now),
            level: level.rawValue,
            message: message.description
        )
        
        let jsonData = try! JSONEncoder().encode(message)
        let jsonString = String(data: jsonData, encoding: .utf8)!

        return jsonString
    }

    /// [apple/swift-log](https://github.com/apple/swift-log)'s log format
    /// `2024-04-12T10:00:07-0310 error: Test error message`
    @MainActor
    public static let appleDefault = BasicFormatter(
        [.timestamp, .group([.level, .text({ _ in ":" })]), .message]
    )
}


func setupLogger(label: String = "", level: Logger.Level) -> Logger {
    var log = Logger(label: label) { label in
        
        let logfmt: any LogFormatter = if app.environment.isRelease {
            JsonFormatter.init()
        } else {
            BasicFormatter([
                    .text({ level in
                        switch level {
                            case .trace: return "💾"
                            case .debug: return "🛠️"
                            case .info: return "📟"
                            case .notice: return "❕"
                            case .warning: return "⚠️"
                            case .error: return "🐞"
                            case .critical: return "❌"
                        }
                    }),
                    .text({ level in "[\(level)]".uppercased() }),
                    .text({ _ in "\(LOG_FORMATTER.string(from: Date()))" }),
                    .text({ _ in label }),
                    .file,
                    .line,
                    .text({ _ in ":" }),
                    .message
                ],
                separator: " "
            )
        }
        
        return CustomHandler(formatter: logfmt, printer: LoggerPrinter.standardOutput)
    }
    
    log.logLevel = level

    return log
}
