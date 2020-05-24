//
//  ChatGroup.swift
//  FirebaseMessagingApp
//
//  Created by Ankit Chaudhary on 24/05/20.
//  Copyright © 2020 webdevlopia. All rights reserved.
//

import Foundation
struct ChatGroupResponse: Codable {
    var chatGroup: [String: GroupDetail] = [:]
    enum CodingKeys: String, CodingKey {
        case chatGroup
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        chatGroup = try values.decode([String: GroupDetail].self, forKey: .chatGroup)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(chatGroup, forKey: .chatGroup)
    }
}


struct GroupDetail: Codable, Hashable {
    var name: String?
    var timestamp: Int?
    var members: [String: Bool] = [:]
    var authorName: String?
    var imageLink: String?
    
    var hashValue: Int {
        return timestamp.hashValue
    }
}
