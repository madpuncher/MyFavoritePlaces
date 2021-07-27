//
//  Places.swift
//  MyFavoritePlaces
//
//  Created by Eʟᴅᴀʀ Tᴇɴɢɪᴢᴏᴠ on 24.07.2021.
//

import RealmSwift
import UIKit

class Place: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var location: String?
    @objc dynamic var type: String?
    @objc dynamic var image: Data?
    @objc dynamic var date = Date()
    @objc dynamic var rating = 0.0

    
    convenience init(name: String, location: String?, type: String?, image: Data?, rating: Double) {
        self.init()
        self.name = name
        self.location = location
        self.type = type
        self.image = image
        self.rating = rating
    }
}
