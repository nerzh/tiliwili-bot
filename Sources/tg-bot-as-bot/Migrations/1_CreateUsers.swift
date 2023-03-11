////
////  File.swift
////  
////
////  Created by Oleh Hudeichuk on 06.06.2021.
////
//
//import Foundation
//import Bridges
//
//struct CreateUser_1: TableMigration {
//    typealias Table = Users
//
//    static func prepare(on conn: BridgeConnection) -> EventLoopFuture<Void> {
//        let builder: CreateTableBuilder<Table> = createBuilder
//        _ = builder.column("id", .bigserial, .primaryKey, .notNull)
//        _ = builder.column("chat_id", .bigint, .unique, .notNull)
//        _ = builder.column("locale_id", .bigint, .notNull)
//        _ = builder.column("user_name", .text, .default("nick"), .notNull)
//        _ = builder.column("first_name", .text, .default("first_name"), .notNull)
//        _ = builder.column("last_name", .text, .default("last_name"), .notNull)
//        _ = builder.column("language_code", .text, .default(""), .notNull)
//        _ = builder.column("is_bot", .bool, .default(false), .notNull)
//        _ = builder.column("wallet_id", .bigint)
//        _ = builder.column("created_at", .timestamptz, .default(Fn.now()), .notNull)
//        _ = builder.column("updated_at", .timestamptz, .default(Fn.now()), .notNull)
//
//        return builder.execute(on: conn)
//    }
//
//    static func revert(on conn: BridgeConnection) -> EventLoopFuture<Void> {
//        let builder: DropTableBuilder<Table> = dropBuilder
//        return builder.execute(on: conn)
//    }
//}
