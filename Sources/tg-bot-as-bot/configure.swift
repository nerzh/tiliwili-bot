//
//  File.swift
//  
//
//  Created by Oleh Hudeichuk on 21.05.2021.
//

import Foundation
import Vapor
//import VaporBridges
//import PostgresBridge
import TelegramVaporBot

///// Postgres config
//extension DatabaseHost {
//    public static var myDefaultHost: DatabaseHost {
//        guard let dbHost = Environment.get("PG_HOST") else { fatalError("Set PG_HOST to .env.your_evironment") }
//        guard let dbPortString = Environment.get("PG_PORT"), let dbPort = Int(dbPortString) else { fatalError("Set PG_PORT to .env.your_evironment") }
//        guard let dbUser = Environment.get("PG_USER") else { fatalError("Set PG_USER to .env.your_evironment") }
//        guard let dbPass = Environment.get("PG_PSWD") else { fatalError("Set PG_PSWD to .env.your_evironment") }
//        return .init(hostname: dbHost, port: dbPort, username: dbUser, password: dbPass, tlsConfiguration: nil)
//    }
//}
//extension DatabaseIdentifier {
//    public static var `default`: DatabaseIdentifier {
//        guard let dbName = Environment.get("PG_DB") else { fatalError("Set PG_DB to .env.your_evironment") }
//        return .init(name: dbName, host: .myDefaultHost, maxConnectionsPerEventLoop: Int(Double(80) / Double(System.coreCount)))
//    }
//}
///// End Postgres config

public func configure(_ app: Application) throws {

    guard let vaporStringPort = Environment.get("vapor_port"),
          let vaporPort = Int(vaporStringPort)
    else { fatalError("Set vapor_port to .env.your_evironment") }
    guard let vaporIp = Environment.get("vapor_ip") else { fatalError("Set vapor_ip to .env.your_evironment") }
    app.http.server.configuration.address = BindAddress.hostname(vaporIp, port: vaporPort)

    app.logger.logLevel = .notice
    // MARK: POSTGRES
//    app.bridges.logger.logLevel = .debug
//    app.postgres.register(.psqlEnvironment)


//    _ = app.postgres.connection(
//        to: .psqlEnvironment
//    ) { (c: PostgresConnection) -> EventLoopFuture<String> in
//        print(c.query("SELECT datname FROM pg_database"))
//        sleep(2)
//        return c.eventLoop.next().future("OK")
//    }
    
    // MARK: MIGRATIONS
//    try migrations(app)

    // MARK: Bot
    guard let tgApi = Environment.get("telegramm_api") else { fatalError("Set telegramm_api to .env.your_evironment") }
    /// set level of debug if you needed
    TGBot.log.logLevel = .info
    let bot: TGBot = .init(app: app, botId: tgApi)
    #if os(Linux)
//        guard let tgIP = Environment.get("telegramm_ip") else { fatalError("Set telegramm_ip to .env.your_evironment") }
        guard let tgWebhookDomain = Environment.get("telegramm_webhook_domain") else { fatalError("Set telegramm_webhook_domain to .env.your_evironment") }
        print("\(tgWebhookDomain)/\(TGWebHookName)")
        TGBotConnection = TGWebHookConnection(bot: bot, webHookURL: "\(tgWebhookDomain)/\(TGWebHookName)")
    #else
        print(tgApi)
        TGBotConnection = TGLongPollingConnection(bot: bot)
    #endif
    Task {
        await MainFlow.addHandlers(app: app, connection: TGBotConnection)
        try await TGBotConnection.start()
    }
    
    
    // MARK: ROUTES
    try routes(app)
}


