//
//  File.swift
//  
//
//  Created by Oleh Hudeichuk on 11.03.2023.
//

import Foundation
import Vapor
import TelegramVaporBot

final class TelegramWebhookController: RouteCollection {
    
    func boot(routes: Vapor.RoutesBuilder) throws {
        routes.get("/", use: test)
        routes.post("\(TGWebHookName)", use: telegramWebHook)
    }
}

extension TelegramWebhookController {
    
    func test(_ req: Request) async throws -> String {
        "Swift works..."
    }
    
    func telegramWebHook(_ req: Request) async throws -> Bool {
        let update: TGUpdate = try req.content.decode(TGUpdate.self)
        return try await TGBOT.connection.dispatcher.process([update])
    }
}
