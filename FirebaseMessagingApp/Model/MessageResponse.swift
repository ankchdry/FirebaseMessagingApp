//
//  Messages.swift
//  FirebaseMessagingApp
//
//  Created by Ankit Chaudhary on 24/05/20.
//  Copyright © 2020 webdevlopia. All rights reserved.
//

import Foundation

struct MessageResponse: Codable {
    var message: [String: MessageDetails] = [:]
    enum CodingKeys: String, CodingKey {
        case message
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try values.decode([String: MessageDetails].self, forKey: .message)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(message, forKey: .message)
    }
}

struct MessageDetails: Codable, Hashable {
    var name: String?
    var timestamp: Int?
    var message: String?
    var userId: String?
    var chatGroup: String?
    
    func toDictionary() -> [String: Any?] {
        return [
            "name": name,
            "timestamp": timestamp,
            "message": message,
            "userId": userId,
            "chatGroup": chatGroup
        ]
    }
    
    var hashValue: Int {
        return timestamp.hashValue
    }
}
