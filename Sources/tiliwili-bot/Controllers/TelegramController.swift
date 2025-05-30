//
//  File.swift
//  
//
//  Created by Oleh Hudeichuk on 11.03.2023.
//

import Foundation
import Vapor
@preconcurrency import SwiftTelegramSdk


final class TelegramController: RouteCollection, Sendable {
    func boot(routes: Vapor.RoutesBuilder) throws {
        routes.get("/", use: test)
        routes.post("\(TGWebHookName)", use: telegramWebHook)
    }
}

extension TelegramController {
    
    func test(_ req: Request) async throws -> String {
        "Swift works..."
    }
    
    func telegramWebHook(_ req: Request) async throws -> Bool {
        let update: TGUpdate = try req.content.decode(TGUpdate.self)
        Task { await app.botActor.bot.dispatcher.process([update]) }
        return true
    }
}
