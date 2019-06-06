//
//  UserController.swift
//  CKUsersPractice
//
//  Created by Dustin Koch on 6/5/19.
//  Copyright © 2019 Rabbit Hole Fashion. All rights reserved.
//

import Foundation
import CloudKit

class UserController {
    
    //MARK: Singleton
    static let shared = UserController()
    private init() {}
    
    //MARK: - Properties
    let publicDB = CKContainer.default().publicCloudDatabase
    
    //MARK: - Source of truth
    var currentUser: User?
    
    //MARK: - CRUD Functions
    
    func createNewUser(username: String, firstName: String, completion: @escaping (Bool) -> Void) {
        CKContainer.default().fetchUserRecordID { (appleUserId, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            }
            guard let appleUserID = appleUserId else { completion(false) ; return }
            let appleUserReference = CKRecord.Reference(recordID: appleUserID, action: .deleteSelf)
            let newUser = User(username: username, firstName: firstName, appleUserReference: appleUserReference)
            let userRecord = CKRecord(user: newUser)
            
            self.publicDB.save(userRecord, completionHandler: { (_, error) in
                if let error = error {
                    print(error.localizedDescription)
                    completion(false)
                    return
                }
                self.currentUser = newUser
                completion(true)
            })
        }
    }//END OF FUNC
    
    func fetchCurrentUser(completion: @escaping (Bool) -> Void) {
        CKContainer.default().fetchUserRecordID { (appleUserRecordID, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            }
            guard let appleUserRecordID = appleUserRecordID else { completion(false); return }
            let appleUserReference = CKRecord.Reference(recordID: appleUserRecordID, action: .deleteSelf)
            
            let predicate = NSPredicate(format: "%K == %@", User.appleUserReferenceKey, appleUserReference)
            let query = CKQuery(recordType: User.userKey, predicate: predicate)
            self.publicDB.perform(query, inZoneWith: nil, completionHandler: { (records, error) in
                if let error = error {
                    print(error.localizedDescription)
                    completion(false)
                    return
                }
                guard let records = records,
                    records.count == 1,
                    let userRecord = records.first
                    else { completion(false); return }
                
                let currentUser = User(ckRecord: userRecord)
                self.currentUser = currentUser
                completion(true)
            })
        }
    }//END OF FETCH
    
}//END OF CLASS
