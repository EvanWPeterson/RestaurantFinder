//
//  RestaurantTableViewController.swift
//  RestaurantFinder
//
//  Created by Evan Peterson on 2/10/17.
//  Copyright © 2017 Evan Peterson. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

// in the simulater under debug set a location
class RestaurantTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    let locationManager = LocationController.shared.locationManger
    var restaurants: [Restaurant] = []
    var zip: CLPlacemark?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                print("Enable Location in Settings")
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.activityType = .automotiveNavigation
                searchRestaurants()
            }
            
        } else {
            NSLog("no location")
        }
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (zip, error) in
            guard let zip = zip?.last, let title = zip.postalCode else { return }
            DispatchQueue.main.async {
                self.title = "\(title)"
                self.zip = zip
            }
        })
    }
    
    
    func searchRestaurants() {
        locationManager.startUpdatingLocation()
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = "Restaurants"
        let search = MKLocalSearch.init(request: request)
        self.restaurants = []
        
        search.start { (response, error) in
            guard let response = response  else {
                print("There was a search error: \(error)")
                return
            }
            
            for item in response.mapItems {
                guard let name = item.name else { return }
                let restaurant = Restaurant(name: name, zip: item.placemark)
                self.restaurants.append(restaurant)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.locationManager.stopUpdatingLocation()
            }
        }
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestCell", for: indexPath)
        
        let restaurant = restaurants[indexPath.row]
        cell.textLabel?.text = restaurant.name
        cell.detailTextLabel?.text = ""
        
        return cell
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        searchRestaurants()
    }
}
