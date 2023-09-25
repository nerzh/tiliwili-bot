//
//  File.swift
//  
//
//  Created by Oleh Hudeichuk on 09.06.2021.
//

import Vapor
import TelegramVaporBot

final class MainFlow {

    static func addHandlers(app: Vapor.Application, connection: TGConnectionPrtcl) async throws {
        try await router(app: app, connection: connection)
    }

    private class func router(app: Vapor.Application, connection: TGConnectionPrtcl) async throws {
        await connection.dispatcher.add(TGBaseHandler({ update, bot in
            Task.detached {
                try await JoinRequestDispatcher(bot: bot).process([update])
                try await TestDispatcher(bot: bot).process([update])
            }
        }))
    }
}
