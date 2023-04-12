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
//struct CreateGames_4: TableMigration {
//    typealias Table = Games
//
//    static func prepare(on conn: BridgeConnection) -> EventLoopFuture<Void> {
//        let builder: CreateTableBuilder<Table> = createBuilder
//        _ = builder.column("id", .bigserial, .primaryKey, .notNull)
//        _ = builder.column("creator_id", .bigint, .notNull)
//        _ = builder.column("amount_participants", .bigint, .notNull)
//        _ = builder.column("game_fee", .bigint)
//        _ = builder.column("winner_id", .bigint)
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
