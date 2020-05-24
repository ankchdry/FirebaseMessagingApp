//
//  ChatGroupsViewModel.swift
//  FirebaseMessagingApp
//
//  Created by Ankit Chaudhary on 24/05/20.
//  Copyright © 2020 webdevlopia. All rights reserved.
//

import Foundation
import FirebaseDatabase
import RxSwift
import RxCocoa
import RxDataSources

class ChatGroupsViewModel: ViewModelType {
    var ref: DatabaseReference!
    var data = BehaviorRelay<[ChatGroupSectionModel]>.init(value: [])
    
    init() { ref = Database.database().reference() }
    
    func updateItems(details: [String: GroupDetail]) {
        var items : [ChatGroupItemSource] = []
        for detail in details.enumerated() {
            let itemSource = ChatGroupItemSource.init(identity: detail.element.value, chatGroupId: detail.element.key)
            items.append(itemSource)
        }
        items.sort(by: { $0.identity.timestamp! > $1.identity.timestamp! })
        let sectionModel = ChatGroupSectionModel.init(model: ChatGroupSection.init(identity: 0), items: items)
        data.accept([sectionModel])
    }
    
    func fetchChatGroups() {
        let userId = (UserDetails.readFromDisk()?.uid) ?? ""
        let chatGroupRefs = self.ref.child("chatGroups").queryOrdered(byChild: "members/\(userId)").queryEqual(toValue: true)
        chatGroupRefs.observe(.value) { [weak self] (snapshot) in
            guard let strongSelf = self else { return }
            if let response = snapshot.value {
                let responseData = try! JSONSerialization.data(withJSONObject: ["chatGroup": response], options: .prettyPrinted)
                let data = try! JSONDecoder.init().decode(ChatGroupResponse.self, from: responseData)
                strongSelf.updateItems(details: data.chatGroup)
            }
        }
    }
}

typealias ChatGroupSectionModel = AnimatableSectionModel<ChatGroupSection, ChatGroupItemSource>
struct ChatGroupSection:IdentifiableType {
    var identity: Int
}

struct ChatGroupItemSource:IdentifiableType, Equatable {
    var identity: GroupDetail
    var chatGroupId: String
    static func == (lhs: ChatGroupItemSource, rhs: ChatGroupItemSource) -> Bool {
        return lhs.identity == rhs.identity
    }
}
