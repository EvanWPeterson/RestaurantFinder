//
//  LocationController.swift
//  RestaurantFinder
//
//  Created by Evan Peterson on 2/10/17.
//  Copyright © 2017 Evan Peterson. All rights reserved.
//

import Foundation
import CoreLocation

class LocationController {
    
    static let shared = LocationController()
    
    var locationManger: CLLocationManager
    
    init() {
        self.locationManger = CLLocationManager()
    }
    
}
