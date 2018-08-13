// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import TrustCore

struct DappCommand: Decodable {
    let name: Method
    let id: Int
    let object: [String: DappCommandObjectValue]
}

struct DappCallback {
    let id: Int
    let value: DappCallbackValue
}

enum DappCallbackValue {
    case signTransaction(Data)
    case sentTransaction(Data)
    case signMessage(Data)
    case signPersonalMessage(Data)
    case signTypedMessage(Data)

    var object: String {
        switch self {
        case .signTransaction(let data):
            return data.hexEncoded
        case .sentTransaction(let data):
            return data.hexEncoded
        case .signMessage(let data):
            return data.hexEncoded
        case .signPersonalMessage(let data):
            return data.hexEncoded
        case .signTypedMessage(let data):
            return data.hexEncoded
        }
    }
}

struct DappCommandObjectValue: Decodable {
    public var value: String = ""
    public var typedData: EIP712TypedData?
    public init(from coder: Decoder) throws {
        let container = try coder.singleValueContainer()
        if let intValue = try? container.decode(Int.self) {
            self.value = String(intValue)
        } else if let typedData = try? container.decode(EIP712TypedData.self) {
            self.typedData = typedData
        } else if let stringValue = try? container.decode(String.self) {
            // possible JSON.stringify(typedData)
            if let data = stringValue.data(using: .utf8) {
                do {
                    self.typedData = try JSONDecoder().decode(EIP712TypedData.self, from: data)
                } catch let error {
                    print(error)
                }
            } else {
                self.value = stringValue
            }
        }
    }
}
