//
//  ResponseEvent.swift
//  OpenAI
//
//  Created by Oleksii Nezhyborets on 06.04.2025.
//

import Foundation

public struct ResponseEvent: Codable, Equatable, Sendable {
    public let response: ResponseObject
    public let sequenceNumber: Int
    public let type: String

    public enum CodingKeys: String, CodingKey {
        case response
        case sequenceNumber = "sequence_number"
        case type
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let parsingOptions = decoder.userInfo[.parsingOptions] as? ParsingOptions ?? []
        self.response = try container.decode(ResponseObject.self, forKey: .response)
        self.sequenceNumber = try container.decode(Int.self, forKey: .sequenceNumber, parsingOptions: parsingOptions, defaultValue: 0)
        self.type = try container.decode(String.self, forKey: .type, parsingOptions: parsingOptions, defaultValue: "")
    }
}