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
    
    /// START VAPOR CONFIGURING
    app.http.server.configuration.address = BindAddress.hostname(VAPOR_IP, port: VAPOR_PORT)
    #if os(Linux)
    app.logger.logLevel = .warning
    #else
    app.logger.logLevel = .notice
    #endif
    
    /// POSTGRES
    try await configureDataBase(app)
    
    /// BOT
    /// set level of debug if you needed
    TGBot.log.logLevel = app.logger.logLevel
    let bot: TGBot = .init(app: app, botId: TG_BOT_ID)
    if env.name == "production" {
        await TGBOT.setConnection(TGWebHookConnection(bot: bot, webHookURL: "\(TG_WEBHOOK_DOMAIN!)/\(TGWebHookName)"))
    } else {
        await TGBOT.setConnection(TGLongPollingConnection(bot: bot))
    }
    
    await MainFlow.addHandlers(app: app, connection: TGBOT.connection)
    try await TGBOT.connection.start()
    
    
    // MARK: ROUTES
    try routes(app)
}


