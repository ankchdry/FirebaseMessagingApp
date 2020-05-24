//
//  UserDetails.swift
//  FirebaseMessagingApp
//
//  Created by Ankit Chaudhary on 24/05/20.
//  Copyright © 2020 webdevlopia. All rights reserved.
//

import Foundation
import FirebaseAuth
class UserDetails: NSObject, Codable, NSCoding {
    var email: String?
    var name: String?
    var uid: String?
    
    init(email:String?, name: String?, uid: String?) {
        self.email = email
        self.name =  name
        self.uid = uid
    }
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("userDetails")
    
    
    required convenience init?(coder aDecoder: NSCoder) {
        let email = aDecoder.decodeObject(forKey: "email") as? String
        let name = aDecoder.decodeObject(forKey: "name") as? String
        let uid = aDecoder.decodeObject(forKey: "uid") as? String
        self.init(email: email, name: name, uid: uid)
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(email, forKey:"email")
        aCoder.encode(name,forKey:"name")
        aCoder.encode(uid, forKey: "uid")
    }
}

extension UserDetails {
    func writeToDisk() {
        let saved = NSKeyedArchiver.archiveRootObject(self, toFile: UserDetails.ArchiveURL.path)
        if saved == true {
            print("User Details saved successfully.")
        }
    }
    
    // Marked static bcoz at reterival time we don't have the object.
    static func readFromDisk() -> UserDetails? {
        guard let userDetails = try NSKeyedUnarchiver.unarchiveObject(withFile: UserDetails.ArchiveURL.path) as? UserDetails else  {
            return nil
        }
        return userDetails
    }
    
    static func delteUserDetailsAndLogOut() -> Bool{
        UserDetails.logOutUser()
        let exists = FileManager.default.fileExists(atPath: UserDetails.ArchiveURL.path)
        if exists {
            do {
                try FileManager.default.removeItem(atPath: UserDetails.ArchiveURL.path)
            }catch let error as NSError {
                print("error: \(error.localizedDescription)")
                return false
            }
        }
        return exists
    }
    
    static func logOutUser() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
}
