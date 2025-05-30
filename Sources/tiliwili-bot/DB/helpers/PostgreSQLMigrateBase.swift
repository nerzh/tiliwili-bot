//
//  File.swift
//  
//
//  Created by Oleh Hudeichuk on 03.04.2023.
//

import Foundation
import PostgresKit
import Vapor
import Fluent


func getDatabase(app: Application) throws -> any Database {
    guard let dataBase = app.databases.database(logger: app.logger, on: app.databases.eventLoopGroup.any()) else {
        throw AppError("Can not find default DataBase in App")
    }
    return dataBase
}


extension SQLDatabase {
    func exist(dbName: String) async throws -> Bool {
        try await raw("SELECT 1 AS result FROM pg_database WHERE datname='\(unsafeRaw: dbName)'").all().get().count > 0
    }
    
    @discardableResult
    func create(dbName: String) async throws -> [SQLRow] {
        try await raw("CREATE DATABASE \(unsafeRaw: dbName)").all().get()
    }
    
    @discardableResult
    func drop(dbName: String) async throws -> [SQLRow] {
        try await raw("DROP DATABASE IF EXIST \(unsafeRaw: dbName)").all().get()
    }
    
    @discardableResult
    func createIfNeeded(dbName: String) async throws -> [SQLRow] {
        if try await exist(dbName: dbName) { return [] }
        return try await create(dbName: dbName)
    }
}
