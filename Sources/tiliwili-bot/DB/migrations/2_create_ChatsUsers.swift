//
//  File.swift
//  
//
//  Created by Oleh Hudeichuk on 14.04.2023.
//

import Foundation
import Bridges

struct Сreate_ChatsUsers_2: TableMigration {
    typealias Table = ChatsUsers

    static func prepare(on conn: BridgeConnection) async throws {
        let builder: CreateTableBuilder<Table> = createBuilder
        _ = builder.column("id", .bigserial, .primaryKey, .notNull)
        _ = builder.column("users_id", .bigint, .notNull)
        _ = builder.column("chats_id", .bigint, .notNull)
        _ = builder.column("approved", .bool, .default(false), .notNull)
        _ = builder.column("banned", .bool, .default(false), .notNull)
        
        _ = builder.column("created_at", .timestamptz, .default(Fn.now()), .notNull)
        _ = builder.column("updated_at", .timestamptz, .default(Fn.now()), .notNull)

        try await builder.execute(on: conn)
    }

    static func revert(on conn: BridgeConnection) async throws {
        let builder: DropTableBuilder<Table> = dropBuilder
        try await builder.execute(on: conn)
    }
}

