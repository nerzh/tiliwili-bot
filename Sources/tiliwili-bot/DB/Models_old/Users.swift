//
//  File.swift
//
//
//  Created by Oleh Hudeichuk on 06.06.2021.
//

import Foundation
import PostgresBridge
import Vapor
import TelegramVaporBot

final class Users: Table {

    @Column("id")
    var id: Int64

    @Column("chat_id")
    var chatId: Int64

    @Column("locale_id")
    var localeId: Int64

    @Column("user_name")
    var nick: String

    @Column("first_name")
    var firstName: String

    @Column("last_name")
    var lastName: String

    @Column("language_code")
    var languageCode: String

    @Column("is_bot")
    var isBot: Bool

    @Column("wallet_id")
    var walletId: Int64?

    @Column("created_at")
    public var createdAt: Date

    @Column("updated_at")
    public var updatedAt: Date

    /// See `Table`
    init() {}

    init(
        chatId: Int64,
        localeId: Int64,
        nick: String,
        firstName: String,
        lastName: String,
        languageCode: String,
        isBot: Bool,
        updatedAt: Date
    ) {
        self.chatId = chatId
        self.localeId = localeId
        self.nick = nick
        self.firstName = firstName
        self.lastName = lastName
        self.languageCode = languageCode
        self.isBot = isBot
        self.updatedAt = updatedAt
    }
}

// MARK: Query Models
extension Users {

    final class Lang: Table {
        @Column("id")
        var id: Int

        @Column("chat_id")
        var chatId: Int

        @Column("locale_id")
        var localeId: Int
    }
}


//// MARK: Queries
//extension Users {
//
//    static func createUserWithDefaultLocale(by update: TGUpdate, on app: Vapor.Application) -> EventLoopFuture<Users?> {
//        let promise: EventLoopPromise<Users?> = app.eventLoop.next().makePromise()
//        return app.postgres.transaction(to: .default) { (conn: PostgresConnection) -> EventLoopFuture<Users?> in
//            guard let from = update.from() else { return conn.eventLoop.next().makeSucceededFuture(nil) }
//            Locales.defaultLocale(update, on: conn).whenComplete { result in
//                if let locale: Locales = unwrapResult(result) {
//                    let user: Users = .init(chatId: from.id,
//                                            localeId: locale.id,
//                                            nick: from.username ?? "",
//                                            firstName: from.firstName,
//                                            lastName: from.lastName ?? "",
//                                            languageCode: from.lastName ?? "",
//                                            isBot: from.isBot,
//                                            updatedAt: Date())
//                    user.upsert(conflictColumn: \Users.$chatId, on: conn).whenComplete { result in
//                        if let newUser: Users = unwrapResult(result) {
//                            promise.succeed(newUser)
//                        } else {
//                            promise.succeed(nil)
//                        }
//                    }
//                }
//            }
//            return promise.futureResult
//        }
//    }
//
//    static func getUser(by chatId: Int, on conn: PostgresConnection) -> EventLoopFuture<Users?> {
//        return SwifQL.select(\Users.$id,
//                              \Users.$chatId,
//                              \Users.$nick,
//                              \Users.$localeId,
//                              \Users.$firstName,
//                              \Users.$lastName,
//                              \Users.$languageCode,
//                              \Users.$isBot,
//                              \Users.$walletId,
//                              \Users.$createdAt,
//                              \Users.$updatedAt)
//            .from(Users.table)
//            .where(\Users.$chatId == chatId)
//            .execute(on: conn)
//            .first(decoding: Users.self)
//    }
//
//    static func createUser(localeId: Int64, update: TGUpdate, on conn: PostgresConnection) -> EventLoopFuture<Users?> {
//        let promise: EventLoopPromise<Users?> = conn.eventLoop.next().makePromise()
//        guard let from = update.from() else { return conn.eventLoop.next().makeSucceededFuture(nil) }
//        let user: Users = .init(chatId: from.id,
//                                localeId: localeId,
//                                nick: from.username ?? "",
//                                firstName: from.firstName,
//                                lastName: from.lastName ?? "",
//                                languageCode: from.lastName ?? "",
//                                isBot: from.isBot,
//                                updatedAt: Date())
//
//        user.upsert(conflictColumn: \Users.$chatId, on: conn).whenComplete { result in
//            if let user: Users = unwrapResult(result) {
//                promise.succeed(user)
//            } else {
//                promise.succeed(nil)
//            }
//        }
//
//        return promise.futureResult
//    }
//}


