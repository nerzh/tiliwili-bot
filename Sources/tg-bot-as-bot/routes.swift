////
////  File.swift
////  
////
////  Created by Oleh Hudeichuk on 21.05.2021.
////
//
import Vapor
import TelegramVaporBot

func routes(_ app: Application) throws {

//    app.post("tg_webhook") { (request) -> EventLoopFuture<String> in
//        do {
//            let update: TGUpdate = try request.content.decode(TGUpdate.self)
//            try TGBot.shared.connection.dispatcher.process([update])
//        } catch {
//            TGBot.log.error(error.logMessage)
//        }
//
//        return app.eventLoop.next().makeSucceededFuture("ok")
//    }
}

