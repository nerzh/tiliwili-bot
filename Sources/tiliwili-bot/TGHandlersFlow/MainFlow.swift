//
//  File.swift
//  
//
//  Created by Oleh Hudeichuk on 09.06.2021.
//

import Vapor
import TelegramVaporBot
//import SwiftTonTool
//import TonClientSwift
//import Bridges

final class MainFlow {

//    private static var loadBalancerQueue: DispatchQueue = .init(label: "com.tg-game-bot.MainBotHandlers.loadBalancerQueue",
//                                                                qos: .default,
//                                                                attributes: .concurrent)

    static func addHandlers(app: Vapor.Application, connection: TGConnectionPrtcl) async {
//        beforeAll(app: app, connection: connection)
//        SelectLangFlow.addHandlers(app: app)
//        WalletFlow.addHandlers(app: app, bot: bot)
        await DefaultFlow.addHandlers(app: app, connection: connection)
    }

//    private static func beforeAll(app: Vapor.Application, connection: TGConnectionPrtcl) {
//        bot.connection.dispatcher.addBeforeAllCallback { (updates: [TGUpdate], callback: @escaping ([TGUpdate]) throws -> Void) in
//            try loadBalancer(app: app, bot: bot, updates: updates) { updates in
//                try callback(updates)
//            }
//        }
//    }
//
//    private static func loadBalancer(app: Vapor.Application,
//                                     bot: TGBotPrtcl,
//                                     updates: [TGUpdate],
//                                     _ callback: @escaping ([TGUpdate]) throws -> Void
//    ) throws {
//        loadBalancerQueue.async {
//            for update in updates {
//                if isValidUpdate(update: update) {
//                    throwingLogWrapper {
//                        let commands = TGSetMyCommandsParams(commands: [
//                                                                .init(command: "/ping", description: "ping"),
//                                                                .init(command: "/keys", description: "Get new keys"),
//                        ])
//                        try bot.setMyCommands(params: commands)
//                    }
////                    echo(update: update, bot: TGBot.shared)
//                    checkUser(app: app, update: update) { bool in
//                        if !bool {
//                            try SelectLangFlow.langDispatcher.process([update])
//                        } else {
//                            CurrentEvents.get(update, app) { (events: [CurrentEvents]) in
//                                if events.isEmpty {
//                                    try callback([update])
//                                } else {
//                                    for event in events {
//                                        eventSwitch(event, update, app, bot)
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//    private static func checkUser(app: Vapor.Application,
//                                  update: TGUpdate,
//                                  _ callback: @escaping (Bool) throws -> Void
//    ) {
//        update.from { user in
//            app.postgres.connection(to: .default) { conn in
//                SwifQL.select(Users.table.*).from(Users.table).where(\Users.$chatId == user.id).execute(on: conn).first(decoding: Users.self)
//            }.whenComplete { result in
//                throwingLogWrapper {
//                    if unwrapResult(result) == nil || unwrapResult(result)! == nil  {
//                        try callback(false)
//                    } else {
//                        try callback(true)
//                    }
//                }
//            }
//        }
//    }
//
//    private static func isValidUpdate(update: TGUpdate) -> Bool {
//        if let userId = update.message?.from?.id, let chatId = update.message?.chat.id {
//            return userId == chatId
//        }
//        if update.message == nil {
//            return true
//        }
//        return false
//    }
//
//    private static func echo(update: TGUpdate, bot: TGBotPrtcl) {
//        throwingLogWrapper {
//            let encodedData = try JSONEncoder().encode(update)
//            let string = String(data: encodedData, encoding: .utf8)
//            _ = update.from { user in
//                try? bot.sendMessage(params: TGSendMessageParams(chatId: .chat(user.id), text: "ECHO: \(String(describing: string))"))
//            }
//        }
//    }
//
//    private static func eventSwitch(_ event: CurrentEvents, _ update: TGUpdate, _ app: Vapor.Application, _ bot: TGBotPrtcl) {
//        throwingLogWrapper {
//            switch event.name {
//            default:
//                break
//            }
//        }
//    }
}

