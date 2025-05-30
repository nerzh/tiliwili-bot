//
//  File.swift
//  
//
//  Created by Oleh Hudeichuk on 21.05.2021.
//

import Foundation
import Vapor
@preconcurrency import SwiftTelegramSdk
import SwiftExtensionsPack

public func configure(_ app: Application, _ env: Environment) async throws {
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
    let connectionType: TGConnectionType = if app.environment == .production {
        .webhook(
            webHookURL: URL.init(
                string: "\(TG_WEBHOOK_DOMAIN)/\(TGWebHookName)"
            )!
        )
    } else {
        .longpolling(
            limit: nil,
            timeout: nil,
            allowedUpdates: nil
        )
    }
    
    let bot: TGBot = try await .init(
        connectionType: connectionType,
        dispatcher: nil,
        tgClient: VaporTGClient(client: app.client),
        tgURI: TGBot.standardTGURL,
        botId: TG_BOT_ID,
        log: app.logger
    )
    
    app.botActor = .init()
    await app.botActor.setBot(bot)
    try await MainFlow.addHandlers(app: app)
    try await app.botActor.bot.start()
    
    /// WATCHERS
    TelegramWatcher.start(checkEverySec: 5 * 60, timeoutSec: 2 * 86400)
    
    /// ROUTES
    try routes(app)
}


