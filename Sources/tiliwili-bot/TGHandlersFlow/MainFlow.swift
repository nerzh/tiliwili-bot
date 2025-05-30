//
//  File.swift
//  
//
//  Created by Oleh Hudeichuk on 09.06.2021.
//

import Vapor
@preconcurrency import SwiftTelegramSdk

final class MainFlow {

    static func addHandlers(app: Vapor.Application) async throws {
        try await router(app: app)
    }

    private class func router(app: Vapor.Application) async throws {
        await app.botActor.bot.dispatcher.add(TGBaseHandler({ update in
            Task.detached { try await JoinRequestDispatcher(log: app.logger).process([update]) }
            Task.detached {try await TestDispatcher(log: app.logger).process([update]) }
            Task.detached {try await DeleteKoreanMessageDispatcher(log: app.logger).process([update]) }
        }))
    }
}
