////
////  File.swift
////
////
////  Created by Oleh Hudeichuk on 09.06.2021.
////
//
//import Foundation
//import PostgresBridge
//import Vapor
//import telegram_vapor_bot
//
//final class LocalizedStrings: Table {
//
//    @Column("id")
//    var id: Int
//
//    @Column("name")
//    var name: String
//
//    @Column("locale_id")
//    var localeId: Int
//
//    @Column("translate")
//    var translate: String
//
//    @Column("created_at")
//    public var createdAt: Date
//
//    @Column("updated_at")
//    public var updatedAt: Date
//
//    /// See `Table`
//    init() {}
//}
//
//// MARK: Query Models
//extension LocalizedStrings {
//
//    final class Translate: Table {
//        @Column("id")
//        var id: Int
//
//        @Column("name")
//        var name: String
//
//        @Column("translate")
//        var translate: String
//    }
//}
//
//
//// MARK: Query Helpers
//extension LocalizedStrings {
//
//    static func l18n(_ name: L18n, _ userId: Int64, on conn: PostgresConnection) -> EventLoopFuture<LocalizedStrings.Translate?> {
//        SwifQL
//            .select(\LocalizedStrings.$id, \LocalizedStrings.$name, \LocalizedStrings.$translate)
//            .from(LocalizedStrings.table)
//            .join(.left, Locales.table, on: \Locales.$id == \LocalizedStrings.$localeId)
//            .join(.left, Users.table, on: \Users.$localeId == \Locales.$id)
//            .where(\Users.$chatId == userId && \LocalizedStrings.$name == name.description)
//            .execute(on: conn)
//            .first(decoding: LocalizedStrings.Translate.self)
//    }
//
//    static func l18n(_ name: L18n, _ langName: String, on conn: PostgresConnection) -> EventLoopFuture<LocalizedStrings.Translate?> {
//        SwifQL
//            .select(\LocalizedStrings.$id, \LocalizedStrings.$name, \LocalizedStrings.$translate)
//            .from(LocalizedStrings.table)
//            .join(.left, Locales.table, on: \Locales.$id == \LocalizedStrings.$localeId)
//            .where(\Locales.$name == langName && \LocalizedStrings.$name == name.description)
//            .execute(on: conn)
//            .first(decoding: LocalizedStrings.Translate.self)
//    }
//
//    static func l18n(_ names: [L18n], _ userId: Int64, on conn: PostgresConnection) -> EventLoopFuture<[LocalizedStrings.Translate]> {
//        let query = SwifQL
//            .select(\LocalizedStrings.$id, \LocalizedStrings.$name, \LocalizedStrings.$translate)
//            .from(LocalizedStrings.table)
//            .join(.left, Locales.table, on: \Locales.$id == \LocalizedStrings.$localeId)
//            .join(.left, Users.table, on: \Users.$localeId == \Locales.$id)
//
//        var parts: SwifQLable = \Users.$chatId == userId
//        var nameParts: SwifQLable!
//        for name in names {
//            if nameParts == nil {
//                nameParts = \LocalizedStrings.$name == name.description
//            } else {
//                nameParts = nameParts || \LocalizedStrings.$name == name.description
//            }
//        }
//
//        parts = parts.and(|nameParts|)
//        return query
//            .where(parts)
//            .execute(on: conn)
//            .all(decoding: LocalizedStrings.Translate.self)
//    }
//
//    static func string(_ name: L18n,
//                       _ userId: Int64,
//                       _ app: Vapor.Application,
//                       _ callback: @escaping (String?) throws -> Void
//    ) {
//        app.postgres.transaction(to: .default) { conn -> EventLoopFuture<LocalizedStrings.Translate?> in
//            l18n(name, userId, on: conn)
//        }.whenComplete { result in
//            do {
//                switch result {
//                case let .success(translate):
//                    try callback(translate?.translate)
//                case let .failure(error):
//                    throw GameError(error.localizedDescription)
//                }
//            } catch {
//                TGBot.log.error(error.rawMessage)
//            }
//        }
//    }
//
//    static func string(_ name: L18n,
//                       _ update: TGUpdate,
//                       _ app: Vapor.Application,
//                       _ callback: @escaping (String?) throws -> Void
//    ) throws {
//        guard let from = update.from() else { throw GameError("withLocalizationString: userId not found") }
//        string(name, from.id, app) { string in
//            try callback(string)
//        }
//    }
//
//    static func strings(_ name: [L18n],
//                        _ userId: Int64,
//                        _ app: Vapor.Application,
//                        _ callback: @escaping ([LocalizedStrings.Translate]) throws -> Void
//    ) {
//        app.postgres.transaction(to: .default) { conn -> EventLoopFuture<[LocalizedStrings.Translate]> in
//            l18n(name, userId, on: conn)
//        }.whenComplete { result in
//            do {
//                switch result {
//                case let .success(arr):
//                    try callback(arr)
//                case let .failure(error):
//                    throw GameError(error.localizedDescription)
//                }
//            } catch {
//                TGBot.log.error(error.rawMessage)
//            }
//        }
//    }
//    
//    static func strings(_ name: [L18n],
//                        _ update: TGUpdate,
//                        _ app: Vapor.Application,
//                        _ callback: @escaping ([LocalizedStrings.Translate]) throws -> Void
//    ) throws {
//        guard let from = update.from() else { throw GameError("withLocalizationString: userId not found") }
//        strings(name, from.id, app) { string in
//            try callback(string)
//        }
//    }
//
//}
