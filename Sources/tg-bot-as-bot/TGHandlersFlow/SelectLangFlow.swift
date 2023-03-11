////
////  File.swift
////  
////
////  Created by Oleh Hudeichuk on 15.06.2021.
////
//
//import Foundation
//import telegram_vapor_bot
//import Vapor
//
//class SelectLangFlow {
//
//    static var langDispatcher: TGDispatcherPrtcl!
//
//    static func addHandlers(app: Vapor.Application) {
//        let bot: TGBot = .shared
//        langDispatcher = LanguageDispatcher(app: app, bot: bot)
//        addSelectLangHandler(app: app, bot: bot)
//        addSetLangHandler(app: app, bot: bot)
//    }
//
//    static func addSelectLangHandler(app: Vapor.Application, bot: TGBotPrtcl) {
//        var keyName: String = KeyboardButtonName.changeLanguage.translate(.ru)
//        bot.connection.dispatcher.add(
//            TGMessageHandler(name: "", filters: .text.value(keyName)) { update, bot in
//                try langDispatcher.process([update])
//            }
//        )
//
//        keyName = KeyboardButtonName.changeLanguage.translate(.en)
//        bot.connection.dispatcher.add(
//            TGMessageHandler(name: "", filters: .text.value(keyName)) { update, bot in
//                try langDispatcher.process([update])
//            }
//        )
//    }
//
//    static func addSetLangHandler(app: Vapor.Application, bot: TGBotPrtcl) {
//        bot.connection.dispatcher.add(
//            TGCallbackQueryHandler(pattern: callbackData(.langSelect, "")) { update, bot in
//                try langDispatcher.process([update])
//            }
//        )
//    }
//}
