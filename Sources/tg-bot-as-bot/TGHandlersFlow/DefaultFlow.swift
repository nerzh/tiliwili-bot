//
//  File.swift
//  
//
//  Created by Oleh Hudeichuk on 01.06.2021.
//

import Vapor
import TelegramVaporBot
//import SwiftTonTool
//import TonClientSwift

final class DefaultFlow {

    static func addHandlers(app: Vapor.Application, connection: TGConnectionPrtcl) async {
        await defaultHandler(app: app, connection: connection)
//        commandPingHandler(app: app, bot: bot)
//        startHandler(app: app, bot: bot)
//        getKeys(app: app, bot: bot)
//        messHandler(app: app, bot: bot)
    }

    private static func defaultHandler(app: Vapor.Application, connection: TGConnectionPrtcl) async {
        await connection.dispatcher.add(TGMessageHandler(filters: (.all && !.command.names(["/ping", "/start", "/keys", "/mess"]))) { update, bot in
            try await update.message?.reply(text: "Success: \(update.message?.text ?? "")", bot: bot)
            let encodedData = try JSONEncoder().encode(update)
            let string = String(data: encodedData, encoding: .utf8)
            try await update.message?.reply(text: "Success: \(String(describing: string))", bot: bot)
        })
    }

//    private static func commandPingHandler(app: Vapor.Application, bot: TGBotPrtcl) {
//        let handler = TGCommandHandler(commands: ["/ping"]) { update, bot in
//            try update.message?.reply(text: "pong", bot: bot)
//        }
//        bot.connection.dispatcher.add(handler)
//    }
//
//    private static func startHandler(app: Vapor.Application, bot: TGBotPrtcl) {
//        let handler = TGCommandHandler(commands: ["/start"]) { update, bot in
////            dump(update)
//        }
//        bot.connection.dispatcher.add(handler)
//    }
//
//    private static func messHandler(app: Vapor.Application, bot: TGBotPrtcl) {
//        let handler = TGCommandHandler(commands: ["/mess"]) { update, bot in
//            let encodedData = try JSONEncoder().encode(update)
//            let string = String(data: encodedData, encoding: .utf8)
//            try update.message?.reply(text: "Success: \(String(describing: string))", bot: bot)
//        }
//        bot.connection.dispatcher.add(handler)
//    }
//
//
//    private static func getKeys(app: Vapor.Application, bot: TGBotPrtcl) {
//        let handler = TGMessageHandler(filters: (.all && .command.names(["/keys"]))) { update, bot in
//            var config: TSDKClientConfig = .init()
//            config.network = TSDKNetworkConfig(server_address: "https://net.ton.dev")
//            let client: TSDKClientModule = .init(config: config)
//            let sdkKit: SwiftTonTool = .init(client: client)
//            sdkKit.getKeysByRandomPhrase { result in
//                switch result {
//                case let .success(keys):
//                    _ = try? bot.sendMessage(params: TGSendMessageParams(chatId: .chat(update.message!.chat.id), text: "\(keys)"))
//                case let .failure(error):
//                    print(error.logMessage)
//                }
//            }
//        }
//        bot.connection.dispatcher.add(handler)
//    }
}

