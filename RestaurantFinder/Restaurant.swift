//
//  Restaurant.swift
//  RestaurantFinder
//
//  Created by Evan Peterson on 2/10/17.
//  Copyright © 2017 Evan Peterson. All rights reserved.
//

import Foundation
import MapKit
class Restaurant {
    
    let name: String
    let zip: MKPlacemark
    
    init(name: String, zip: MKPlacemark) {
        self.name = name
        self.zip = zip 
        
    }
}
