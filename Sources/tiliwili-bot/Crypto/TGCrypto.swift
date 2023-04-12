////
////  File.swift
////
////
////  Created by Oleh Hudeichuk on 07.06.2021.
////
//
//import Foundation
//import Vapor
//
//public extension Data {
//    init?(hexString: String) {
//      let len = hexString.count / 2
//      var data = Data(capacity: len)
//      var i = hexString.startIndex
//      for _ in 0..<len {
//        let j = hexString.index(i, offsetBy: 2)
//        let bytes = hexString[i..<j]
//        if var num = UInt8(bytes, radix: 16) {
//          data.append(&num, count: 1)
//        } else {
//          return nil
//        }
//        i = j
//      }
//      self = data
//    }
//    /// Hexadecimal string representation of `Data` object.
//    var hexadecimal: String {
//        return map { String(format: "%02x", $0) }
//            .joined()
//    }
//}
//
//public final class TGCrypto {
//
//    private static var key: String {
//        guard let cryptoKey = Environment.get("crypto_key") else { fatalError("Set crypto_key to .env.your_evironment") }
//        return cryptoKey
//    }
//
//    private static var dataOfKey: Data {
//        guard let result = Data(hexString: key) else { fatalError("Can not convert Key to Data") }
//        return result
//    }
//
//    public static func encode(_ value: String) throws -> String {
//        guard let valueData: Data = value.data(using: .utf16) else {
//            fatalError("Can not convert encrypted value to Data")
//        }
//        let key = SymmetricKey.init(data: dataOfKey)
//        let sealedBox: AES.GCM.SealedBox = try AES.GCM.seal(valueData, using: key)
//        guard let result: String = sealedBox.combined?.base64EncodedString() else {
//            fatalError("Can not convert encrypted value to Data")
//        }
//
//        return result
//    }
//
//    public static func decode(_ base64EncryptedValue: String) throws -> String {
//        guard let encryptedData: Data = Data(base64Encoded: base64EncryptedValue) else {
//            fatalError("Can not convert encrypted value to Data")
//        }
//        let key = SymmetricKey.init(data: dataOfKey)
//        let sealedBox: AES.GCM.SealedBox = try .init(combined: encryptedData)
//        let decrypted: Data = try AES.GCM.open(sealedBox, using: key)
//        guard let result: String = String(data: decrypted, encoding: .utf16) else {
//            fatalError("Can not convert encrypted value to Data")
//        }
//        return result
//    }
//}
//
