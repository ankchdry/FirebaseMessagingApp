//
//  MemberResponse.swift
//  FirebaseMessagingApp
//
//  Created by Ankit Chaudhary on 24/05/20.
//  Copyright © 2020 webdevlopia. All rights reserved.
//

import Foundation
struct MemberResponse: Codable {
    var member: [String: MemberDetails] = [:]
    enum CodingKeys: String, CodingKey {
        case member
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        member = try values.decode([String: MemberDetails].self, forKey: .member)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(member, forKey: .member)
    }
}


struct MemberDetails: Codable {
    var name: String?
    var email: Int?
    var chatGroups: [String: Bool] = [:]
    var created: String?
    
    var hashValue: Int {
        return email.hashValue
    }
}

