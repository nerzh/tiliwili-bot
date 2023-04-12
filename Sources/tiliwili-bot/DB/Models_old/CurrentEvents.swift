////
////  File.swift
////  
////
////  Created by Oleh Hudeichuk on 15.06.2021.
////
//
//import Foundation
//import SwifQL
//import Bridges
//import Vapor
//import telegram_vapor_bot
//
//final class CurrentEvents: Table {
//
//    @Column("id")
//    var id: Int64
//
//    @Column("user_id")
//    var userId: Int64
//
//    @Column("name")
//    var name: String
//
//    @Column("data")
//    var data: String
//
//    @Column("complete")
//    var complete: Bool
//    
//    @Column("created_at")
//    public var createdAt: Date
//
//    @Column("updated_at")
//    public var updatedAt: Date
//
//    /// See `Table`
//    init() {}
//
//    init(userId: Int64, name: String, data: String = "", complete: Bool = false, updatedAt: Date = Date()) {
//        self.userId = userId
//        self.name = name
//        self.data = data
//        self.complete = complete
//        self.updatedAt = updatedAt
//    }
//}
//
//
//// MARK: query models
//
//extension CurrentEvents {
//    enum Name: String {
//        case a
//    }
//}
//
//
//// MARK: query methods
//
//extension CurrentEvents {
//
//    static func get(_ update: TGUpdate,
//                    _ app: Vapor.Application,
//                    _ callback: @escaping (CurrentEvents?) throws -> Void
//    ) {
//        throwingLogWrapper {
//            if let from = update.from() {
//                app.postgres.transaction(to: .default) { conn in
//                    SwifQL
//                        .select(CurrentEvents.table.*)
//                        .from(CurrentEvents.table)
//                        .where(\CurrentEvents.$userId == from.id)
//                        .execute(on: conn)
//                        .first(decoding: CurrentEvents.self)
//                }.whenComplete { result in
//                    throwingLogWrapper {
//                        if let result = unwrapResult(result) {
//                            try callback(result)
//                        } else {
//                            try callback(nil)
//                        }
//                    }
//                }
//            } else {
//                try callback(nil)
//            }
//        }
//    }
//
//    static func get(_ update: TGUpdate,
//                    _ app: Vapor.Application,
//                    _ callback: @escaping ([CurrentEvents]) throws -> Void
//    ) {
//        throwingLogWrapper {
//            if let from = update.from() {
//                app.postgres.transaction(to: .default) { conn in
//                    SwifQL
//                        .select(CurrentEvents.table.*)
//                        .from(CurrentEvents.table)
//                        .where(\CurrentEvents.$userId == from.id)
//                        .execute(on: conn)
//                        .all(decoding: CurrentEvents.self)
//                }.whenComplete { result in
//                    throwingLogWrapper {
//                        if let events = unwrapResult(result) {
//                            try callback(events)
//                        } else {
//                            try callback([])
//                        }
//                    }
//                }
//            } else {
//                try callback([])
//            }
//        }
//    }
//
//    static func getOrUpdate(_ name: CurrentEvents.Name,
//                            _ data: String,
//                            _ update: TGUpdate,
//                            _ app: Vapor.Application
//    ) throws -> EventLoopFuture<CurrentEvents> {
//        if let from = update.from() {
//           return app.postgres.transaction(to: .default) { conn in
//                SwifQL
//                    .select(CurrentEvents.table.*)
//                    .from(CurrentEvents.table)
//                    .where(\CurrentEvents.$userId == from.id && \CurrentEvents.$name == name.rawValue)
//                    .execute(on: conn)
//                    .first(decoding: CurrentEvents.self)
//                    .flatMap { event in
//                        let promise: EventLoopPromise<CurrentEvents> = app.eventLoop.next().makePromise()
//                        if let event = event {
//                            if !event.complete {
//                                promise.succeed(event)
//                            } else {
//                                event.data = data
//                                event.complete = false
//                                event.update(on: \CurrentEvents.$id, on: conn).whenSuccess { event in
//                                    promise.succeed(event)
//                                }
//                            }
//                        } else {
//                            CurrentEvents
//                                .init(userId: from.id, name: name.rawValue, data: data)
//                                .insert(on: conn)
//                                .whenSuccess
//                            { event in
//                                promise.succeed(event)
//                            }
//                        }
//
//                        return promise.futureResult
//                    }
//            }
//        } else {
//            throw GameError.init("CurrentEvents.insert: User chat id not found")
//        }
//    }
//}
//
//
