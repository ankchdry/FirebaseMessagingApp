//
//  ChatGroupDetailsViewModel.swift
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
class ChatGroupDetailsViewModel: ViewModelType {
    var ref: DatabaseReference!
    
    // Group ID.
    var groupName: String!
    var data = BehaviorRelay<[MessageSectionModel]>.init(value: [])
    
    func updateItems(details: [String: MessageDetails]) {
        let userId = UserDetails.readFromDisk()?.uid
        var items : [MessageItemSource] = []
        for detail in details.enumerated() {
            let itemSource = MessageItemSource.init(identity: detail.element.value, messageId: detail.element.key, isloggedInUserMessage: detail.element.value.userId == userId)
            items.append(itemSource)
        }
        items.sort(by: { $0.identity.timestamp! < $1.identity.timestamp! })
        let sectionModel = MessageSectionModel.init(model: MessageSection.init(identity: 0), items: items)
        data.accept([sectionModel])
    }
    
    func fetchGroupChats() {
        let messageRefs = self.ref.child("messages").queryOrdered(byChild: "chatGroup").queryEqual(toValue: groupName)
        messageRefs.observe(.value) { [weak self] (snapshot) in
            guard let strongSelf = self else { return }
            if let response = snapshot.value, !(response is NSNull) {
                
                let responseData = try! JSONSerialization.data(withJSONObject: ["message": response], options: .prettyPrinted)
                let data = try! JSONDecoder.init().decode(MessageResponse.self, from: responseData)
                strongSelf.updateItems(details: data.message)
            }
        }
    }
    
    func createConversation(for msg: String) {
        let userDetails = UserDetails.readFromDisk()
        let messageDetails = MessageDetails.init(name: userDetails?.name, timestamp: Int(Date().timeIntervalSince1970), message: msg, userId: userDetails?.uid, chatGroup: groupName)
        let randomId = UUID.init().uuidString
        self.ref.child("messages/\(randomId)").setValue(messageDetails.toDictionary())
    }
}

typealias MessageSectionModel = AnimatableSectionModel<MessageSection, MessageItemSource>
struct MessageSection:IdentifiableType {
    var identity: Int
}
struct MessageItemSource:IdentifiableType, Equatable {
    
    var identity: MessageDetails
    var messageId: String
    var isloggedInUserMessage: Bool
    
    static func == (lhs: MessageItemSource, rhs: MessageItemSource) -> Bool {
        return lhs.identity == rhs.identity
    }
}

