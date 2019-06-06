//
//  User.swift
//  CKUsersPractice
//
//  Created by Dustin Koch on 6/5/19.
//  Copyright © 2019 Rabbit Hole Fashion. All rights reserved.
//

import Foundation
import CloudKit

class User {
    let username: String
    let firstName: String
    let appleUserReference: CKRecord.Reference
    var recordID: CKRecord.ID?
    
    static let userKey = "User"
    fileprivate static let usernameKey = "username"
    fileprivate static let firstNameKey = "firstName"
    static let appleUserReferenceKey = "appleUserReference"
    
    init(username: String, firstName: String, appleUserReference: CKRecord.Reference) {
        self.username = username
        self.firstName = firstName
        self.appleUserReference = appleUserReference
    }
    
    init?(ckRecord: CKRecord) {
        guard let username = ckRecord[User.usernameKey] as? String,
            let firstName = ckRecord[User.firstNameKey] as? String,
            let appleUserReference = ckRecord[User.appleUserReferenceKey] as? CKRecord.Reference
            else { return nil }
        
        self.username = username
        self.firstName = firstName
        self.appleUserReference = appleUserReference
        self.recordID = ckRecord.recordID
        
    }
    
}//END OF CLASS

extension CKRecord {
    
    convenience init(user: User) {
        let recordID = user.recordID ?? CKRecord.ID(recordName: UUID().uuidString)
        self.init(recordType: User.userKey, recordID: recordID)
        self.setValue(user.username, forKey: User.usernameKey)
        self.setValue(user.firstName, forKey: User.firstNameKey)
        self.setValue(user.appleUserReference, forKey: User.appleUserReferenceKey)
        user.recordID = recordID
    }
}//END OF EXTENSION
