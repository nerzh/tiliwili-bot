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
//struct CreateGamesUsers_5: TableMigration {
//    typealias Table = GamesUsers
//
//    static func prepare(on conn: BridgeConnection) -> EventLoopFuture<Void> {
//        let builder: CreateTableBuilder<Table> = createBuilder
//        _ = builder.column("id", .bigserial, .primaryKey, .notNull)
//        _ = builder.column("game_id", .bigint, .notNull)
//        _ = builder.column("user_id", .bigint, .notNull)
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
