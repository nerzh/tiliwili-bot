////
////  File.swift
////  
////
////  Created by Oleh Hudeichuk on 09.06.2021.
////
//
//import Foundation
//import TelegramVaporBot
//import Vapor
//
//final class LanguageDispatcher: TGDefaultDispatcher {
//
//    weak var app: Vapor.Application?
//
//    init(app: Vapor.Application, bot: TGBot) {
//        super.init()
//        self.bot = bot
//        self.app = app
//        setLangHandler(app: app)
//        getLangHandler()
//    }
//
//    private func setLangHandler(app: Vapor.Application) {
//        add(TGMessageHandler(filters: .all) { update, bot in
//            let keyboard: TGInlineKeyboardMarkup = .init(inlineKeyboard: [
//                [
//                    .init(text: "ru", callbackData: callbackData(.langSelect, "ru")),
//                    .init(text: "en", callbackData: callbackData(.langSelect, "en"))
//                ]
//            ])
//            try LocalizedStrings.string(.langSelectLang, update, app) { string in
//                try update.message?.reply(text: string ?? "Выбери язык !", bot: bot, replyMarkup: .inlineKeyboardMarkup(keyboard))
//            }
//        })
//    }
//
//    private func getLangHandler() {
//        add(TGCallbackQueryHandler(pattern: callbackData(.langSelect, "")) { [weak self] update, bot in
//            guard
//                let data = update.callbackQuery?.data,
//                let value = callbackDataValue(.langSelect, data),
//                let app = self?.app
//            else { return }
//            let locale: Locales = .init(name: value, updatedAt: Date())
//            _ = app.postgres.transaction(to: .default) { (conn) -> EventLoopFuture<Bool> in
//                locale.upsert(conflictColumn: \Locales.$name, on: conn).whenSuccess { (locale: Locales) in
//                    Users.createUser(localeId: locale.id, update: update, on: conn).whenSuccess { user in
//                        if user != nil, let from = update.from() {
//                            do {
//                                try showKeyboard(lang: locale.name, userId: from.id, app: app, bot: bot)
//                                try update.callbackQuery?.message?.delete(bot: bot)
//                            } catch {}
//                        }
//                    }
//                }
//                return conn.eventLoop.next().makeSucceededFuture(true)
//            }
//        })
//    }
//}
