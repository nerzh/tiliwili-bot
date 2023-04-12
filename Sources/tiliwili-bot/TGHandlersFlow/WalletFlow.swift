////
////  File.swift
////  
////
////  Created by Oleh Hudeichuk on 17.06.2021.
////
//
//import Vapor
//import telegram_vapor_bot
//import SwiftTonTool
//import TonClientSwift
//import Bridges
//
//final class WalletFlow {
//
//    static var walletDispatcher: TGDispatcherPrtcl!
//
//    static func addHandlers(app: Vapor.Application, bot: TGBotPrtcl) {
//        let bot: TGBot = .shared
//        walletDispatcher = LanguageDispatcher(app: app, bot: bot)
//        addSelectWalletHandler(app: app, bot: bot)
//    }
//
//    private static func beforeAll(app: Vapor.Application, bot: TGBotPrtcl) {
////        bot.connection.dispatcher.addBeforeAllCallback { (updates: [TGUpdate], callback: @escaping ([TGUpdate]) throws -> Void) in
////            try loadBalancer(app: app, bot: bot, updates: updates) { updates in
////                try callback(updates)
////            }
////        }
//    }
//
//    static func addSelectWalletHandler(app: Vapor.Application, bot: TGBotPrtcl) {
//        var keyName: String = KeyboardButtonName.wallet.translate(.ru)
//        bot.connection.dispatcher.add(
//            TGMessageHandler(name: "", filters: .text.value(keyName)) { update, bot in
//                try walletDispatcher.process([update])
//            }
//        )
//
//        keyName = KeyboardButtonName.wallet.translate(.en)
//        bot.connection.dispatcher.add(
//            TGMessageHandler(name: "", filters: .text.value(keyName)) { update, bot in
//                try walletDispatcher.process([update])
//            }
//        )
//    }
//
//
//}
//
//
