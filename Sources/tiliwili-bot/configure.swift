//
//  File.swift
//  
//
//  Created by Oleh Hudeichuk on 21.05.2021.
//

import Foundation
import Vapor
import VaporBridges
import PostgresBridge
import TelegramVaporBot

public func configure(_ app: Application) async throws {
    let env = try Environment.detect()
    
    /// GET ENV
    try getAllEnvConstants()
    
    /// START VAPOR CONFIGURING
    app.http.server.configuration.address = BindAddress.hostname(VAPOR_IP, port: VAPOR_PORT)
    #if os(Linux)
    app.logger.logLevel = .warning
    #else
    app.logger.logLevel = .debug
    #endif
    
    /// POSTGRES
    try await configureDataBase(app)
    
    /// BOT
    /// set level of debug if you needed
    TGBot.log.logLevel = app.logger.logLevel
    let bot: TGBot = .init(app: app, botId: TG_BOT_ID)
    if env.name == "production" {
        await TGBOT.setConnection(try await TGWebHookConnection(bot: bot, webHookURL: "\(TG_WEBHOOK_DOMAIN!)/\(TGWebHookName)"))
    } else {
        await TGBOT.setConnection(try await TGLongPollingConnection(bot: bot))
    }
    
    try await MainFlow.addHandlers(app: app, connection: TGBOT.connection)
    try await TGBOT.connection.start()
    
    /// WATCHERS
    TelegramWatcher.start(checkEverySec: 5 * 60, timeoutSec: 2 * 86400)
    
    /// ROUTES
    try routes(app)
}


