//
//  Entry.swift
//  CKUsersPractice
//
//  Created by Dustin Koch on 6/6/19.
//  Copyright © 2019 Rabbit Hole Fashion. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

class Entry {
    var title: String
    var body: String
    var image: UIImage
    var imageData: Data? {
        return image.pngData()
    }
    let userReference: CKRecord.Reference
    
    static let entryKey = "Entry"
    static let userReferenceKey = "userReference"
    static let titleKey = "title"
    static let bodyKey = "body"
    static let imageAssetKey = "imageAsset"
    
    init(title: String, body: String, image: UIImage, userReference: CKRecord.Reference) {
        self.title = title
        self.body = body
        self.image = image
        self.userReference = userReference
    }
    
    convenience init?(ckRecord: CKRecord) {
        guard let title = ckRecord[Entry.titleKey] as? String,
            let body = ckRecord[Entry.bodyKey] as? String,
            let userReference = ckRecord[Entry.userReferenceKey] as? CKRecord.Reference,
            let imageAsset = ckRecord[Entry.imageAssetKey] as? CKAsset else { return nil }
        
        let imageData = try? Data(contentsOf: imageAsset.fileURL!)
        
        self.init(title: title, body: body, image: UIImage(data: imageData!) ?? UIImage(), userReference: userReference)    }
    
}//END OF CLASS

extension CKRecord {
    convenience init(entry: Entry) {
        self.init(recordType: Entry.entryKey)
        
        let tempDirectory = NSTemporaryDirectory()
        let tempDirectoryURL = URL(fileURLWithPath: tempDirectory)
        let fileURL = tempDirectoryURL.appendingPathComponent(entry.title).appendingPathExtension("jpg")
        do {
            try entry.imageData?.write(to: fileURL)
        } catch {
            print(error.localizedDescription)
        }
        
        let imageAsset = CKAsset(fileURL: fileURL)
        
        setValue(entry.title, forKey: Entry.titleKey)
        setValue(entry.body, forKey: Entry.bodyKey)
        setValue(entry.userReference, forKey: Entry.userReferenceKey)
        setValue(imageAsset, forKey: Entry.imageAssetKey)
    }
}
