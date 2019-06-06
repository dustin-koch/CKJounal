//
//  EntryController.swift
//  CKUsersPractice
//
//  Created by Dustin Koch on 6/6/19.
//  Copyright © 2019 Rabbit Hole Fashion. All rights reserved.
//

import UIKit
import CloudKit

class EntryController {
    
    //MARK: - Singleton
    static let shared = EntryController()
    
    //MARK: - Source of truth
    var entries: [Entry] = []
    let publicDB = CKContainer.default().publicCloudDatabase
    
    //MARK: CRUD
    
    func createNewEntry(title: String, body: String, image: UIImage, completion: @escaping (Bool) -> Void) {
        guard let userRecordID = UserController.shared.currentUser?.recordID else { completion(false); return }
        let userReference = CKRecord.Reference(recordID: userRecordID, action: .deleteSelf)
        
        let entry = Entry(title: title, body: body, image: image, userReference: userReference)
        
        let entryRecord = CKRecord(entry: entry)
        self.publicDB.save(entryRecord) { (record, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            }
            guard let record = record,
                let newEntry = Entry(ckRecord: record) else { completion(false); return }
            self.entries.append(newEntry)
            completion(true)
        }
    }
    
    func fetchEntriesFor(user: User, completion: @escaping (Bool) -> Void) {
        let userRecord = CKRecord(user: user)
        let userReference = CKRecord.Reference(record: userRecord, action: .deleteSelf)
        let predicate = NSPredicate(format: "%K == %@", Entry.userReferenceKey, userReference)
        let query = CKQuery(recordType: Entry.entryKey, predicate: predicate)
        
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            }
            guard let records = records else { return }
            let entries = records.compactMap { return Entry(ckRecord: $0) }
            self.entries = entries
            completion(true)
        }
    }
    
    func delete(entry: Entry, completion: @escaping (Bool) -> Void) {
        let entryRecord = CKRecord(entry: entry)
        
        publicDB.delete(withRecordID: entryRecord.recordID) { (_, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
                return
            }
            completion(true)
        }
    }
    
}//END OF CLASS

