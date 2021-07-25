//
//  Places.swift
//  MyFavoritePlaces
//
//  Created by Eʟᴅᴀʀ Tᴇɴɢɪᴢᴏᴠ on 24.07.2021.
//

import UIKit

struct Place {
    var name: String
    var location: String?
    var type: String?
    var restaurantImage: String?
    var image: UIImage?
    
    static let favoriteRestaurants = [
        "Burger Heroes", "Kitchen", "Bonsai", "Дастархан",
        "Индокитай", "X.O", "Балкан Гриль", "Sherlock Holmes",
        "Speak Easy", "Morris Pub", "Вкусные истории",
        "Классик", "Love&Life", "Шок", "Бочка"
    ]
    static func getPlaces() -> [Place] {
        
        var places = [Place]()
        
        for place in favoriteRestaurants {
            places.append(Place(name: place, location: "Москва", type: "Ресторан", restaurantImage: place, image: nil))
        }
        
        return places
    }
}
