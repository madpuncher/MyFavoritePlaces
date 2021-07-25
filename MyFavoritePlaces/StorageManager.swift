//
//  StorageManager.swift
//  MyFavoritePlaces
//
//  Created by Eʟᴅᴀʀ Tᴇɴɢɪᴢᴏᴠ on 25.07.2021.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    static func saveObjects(_ object: Place) {
        try! realm.write {
            realm.add(object)
        }
    }
    
    static func deleteObject(_ object: Place) {
        try! realm.write {
            realm.delete(object)
        }
    }
}
