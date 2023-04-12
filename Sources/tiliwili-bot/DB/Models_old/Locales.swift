////
////  File.swift
////  
////
////  Created by Oleh Hudeichuk on 09.06.2021.
////
//
//import Foundation
//import SwifQL
//import telegram_vapor_bot
//import PostgresNIO
//
//final class Locales: Table {
//
//    @Column("id")
//    var id: Int64
//
//    @Column("name")
//    var name: String
//    
//    @Column("created_at")
//    public var createdAt: Date
//
//    @Column("updated_at")
//    public var updatedAt: Date
//
//    init() {}
//
//    public init(name: String, updatedAt: Date) {
//        self.name = name
//        self.updatedAt = updatedAt
//    }
//}
//
//extension Locales {
//
//    static func defaultLocale(_ update: TGUpdate, on conn: PostgresConnection) -> EventLoopFuture<Locales> {
//        let `default`: String = "ru"
//        let locale: Locales = .init(name: update.message?.from?.languageCode ?? `default`, updatedAt: Date())
//        return locale.upsert(conflictColumn: \Locales.$name, on: conn)
//    }
//}
//
//
