////
////  File.swift
////  
////
////  Created by Oleh Hudeichuk on 06.06.2021.
////
//
//import Vapor
//import PostgresBridge
//
//func migrations(_ app: Application) throws {
//    let migrator = app.postgres.migrator(for: .default)
//
//    migrator.add(CreateUser_1.self)
//    migrator.add(CreateWalets_2.self)
//    migrator.add(CreateLocales_3.self)
//    migrator.add(CreateGames_4.self)
//    migrator.add(CreateGamesUsers_5.self)
//    migrator.add(CreateLocalizedStrings_6.self)
//    migrator.add(CreateCurrentEvent_7.self)
//
//    try migrator.migrate().wait() // will run all provided migrations one by one inside a transaction
////    try migrator.revertLast().wait() // will revert only last batch
////    try migrator.revertAll().wait() // will revert all migrations one by one in desc order
//}
