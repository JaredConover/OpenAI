//
//  KeyedDecodingContainer+ParsingOptions.swift
//  OpenAI
//
//  Created by Oleksii Nezhyborets on 27.03.2025.
//

import Foundation

extension KeyedDecodingContainer {
    func decodeString(forKey key: KeyedDecodingContainer<K>.Key, parsingOptions: ParsingOptions) throws -> String {
        try self.decode(String.self, forKey: key, parsingOptions: parsingOptions, defaultValue: "")
    }
    
    func decodeTimeInterval(forKey key: KeyedDecodingContainer<K>.Key, parsingOptions: ParsingOptions) throws -> TimeInterval {
        try self.decode(TimeInterval.self, forKey: key, parsingOptions: parsingOptions, defaultValue: 0)
    }
    
    func decode<T: Decodable>(_ type: T.Type, forKey key: KeyedDecodingContainer<K>.Key, parsingOptions: ParsingOptions, defaultValue: T) throws -> T {
        do {
            return try decode(T.self, forKey: key)
        } catch {
            switch error {
            case DecodingError.keyNotFound:
                if parsingOptions.contains(.fillRequiredFieldIfKeyNotFound) {
                    return defaultValue
                } else {
                    throw error
                }
            case DecodingError.valueNotFound:
                if parsingOptions.contains(.fillRequiredFieldIfValueNotFound) {
                    return defaultValue
                } else {
                    throw error
                }
            default:
                throw error
            }
        }
    }

    /// Apply the parsing options to non-primitive types allowing relaxed parsing when specified.
    /// Useful for alternative or custom implementations that may not return all properties in the JSON.
    func decodeRequiredComplex<T: Decodable>(_ type: T.Type, forKey key: KeyedDecodingContainer<K>.Key, parsingOptions: ParsingOptions) throws -> T? {
        if let value = try self.decodeIfPresent(T.self, forKey: key) {
            return value
        }

        if self.contains(key) {
            if parsingOptions.contains(.fillRequiredFieldIfValueNotFound) {
                return nil
            } else {
                throw DecodingError.valueNotFound(
                    T.self,
                    DecodingError.Context(
                        codingPath: self.codingPath + [key],
                        debugDescription: "Value not found for key '\(key.stringValue)'"
                    )
                )
            }
        } else {
            if parsingOptions.contains(.fillRequiredFieldIfKeyNotFound) {
                return nil
            } else {
                throw DecodingError.keyNotFound(
                    key,
                    DecodingError.Context(
                        codingPath: self.codingPath + [key],
                        debugDescription: "Missing required key '\(key.stringValue)'"
                    )
                )
            }
        }
    }
}
