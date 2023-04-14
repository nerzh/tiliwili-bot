//
//  File.swift
//  
//
//  Created by Oleh Hudeichuk on 14.04.2023.
//

import Foundation
import Bridges

struct Сreate_JoinRequests_3: TableMigration {
    typealias Table = JoinRequests

    static func prepare(on conn: BridgeConnection) async throws {
        let builder: CreateTableBuilder<Table> = createBuilder
        _ = builder.column("id", .bigserial, .primaryKey, .notNull)
        _ = builder.column("users_id", .bigint, .notNull)
        _ = builder.column("chats_id", .bigint, .notNull)
        _ = builder.column("element", .text, .default(""), .notNull)
        
        _ = builder.column("created_at", .timestamptz, .default(Fn.now()), .notNull)
        _ = builder.column("updated_at", .timestamptz, .default(Fn.now()), .notNull)

        try await builder.execute(on: conn)
    }

    static func revert(on conn: BridgeConnection) async throws {
        let builder: DropTableBuilder<Table> = dropBuilder
        try await builder.execute(on: conn)
    }
}

