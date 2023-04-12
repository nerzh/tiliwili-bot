////
////  File.swift
////  
////
////  Created by Oleh Hudeichuk on 15.06.2021.
////
//
//import Foundation
//import Bridges
//
//struct CreateCurrentEvent_7: TableMigration {
//    typealias Table = CurrentEvents
//
//    static func prepare(on conn: BridgeConnection) -> EventLoopFuture<Void> {
//        let builder: CreateTableBuilder<Table> = createBuilder
//        _ = builder.column("id", .bigserial, .primaryKey, .notNull)
//        _ = builder.column("user_id", .bigint, .notNull)
//        _ = builder.column("name", .text, .notNull)
//        _ = builder.column("data", .text, .default(""), .notNull)
//        _ = builder.column("complete", .bool, .default(false), .notNull)
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
//
