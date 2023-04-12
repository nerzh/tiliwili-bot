////
////  File.swift
////  
////
////  Created by Oleh Hudeichuk on 10.06.2021.
////
//
//import Foundation
//import telegram_vapor_bot
//import Vapor
//import Bridges
//import PostgresNIO
//
//enum GameLanguages: String {
//    case ru
//    case en
//}
//
//enum KeyboardButtonName: String {
//    case createGame
//    case changeLanguage
//    case wallet
//
//    private static var translateData: [String: [String: String]] = [
//        Self.createGame.rawValue: [
//            "ru": "Создать игру",
//            "en": "Create game",
//        ],
//        Self.changeLanguage.rawValue: [
//            "ru": "Изменить язык",
//            "en": "Change locale"
//        ],
//        Self.wallet.rawValue: [
//            "ru": "Кошелек",
//            "en": "Wallet"
//        ]
//    ]
//
//    func translate(_ lang: GameLanguages) -> String {
//        Self.translateData[rawValue]?[lang.rawValue] ?? "Button not translated"
//    }
//
//    func translate(_ lang: String) -> String {
//        Self.translateData[rawValue]?[lang] ?? "Button not translated"
//    }
//}
//
//func showKeyboard(lang: String, userId: Int64, app: Vapor.Application, bot: TGBotPrtcl) throws {
//    LocalizedStrings.string(.setKeboard, userId, app, { string in
//        let buttons: [[TGKeyboardButton]] = [
//            [
//                .init(text: KeyboardButtonName.createGame.translate(lang)),
//                .init(text: KeyboardButtonName.changeLanguage.translate(lang)),
//                .init(text: KeyboardButtonName.wallet.translate(lang))
//            ]
//        ]
//        let keyboard: TGReplyKeyboardMarkup = .init(keyboard: buttons,
//                                                    resizeKeyboard: true,
//                                                    oneTimeKeyboard: true,
//                                                    selective: false)
//        let params: TGSendMessageParams = .init(chatId: .chat(userId),
//                                                text: string ?? "Show keyboard",
//                                                replyMarkup: .replyKeyboardMarkup(keyboard))
//        try bot.sendMessage(params: params)
//    })
//}
