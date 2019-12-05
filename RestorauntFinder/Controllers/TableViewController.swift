//
//  ViewController.swift
//  RestorauntFinder
//
//  Created by Karlis Cars on 05/12/2019.
//  Copyright © 2019 Karlis Cars. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class TableViewController: UITableViewController, CLLocationManagerDelegate {

    let locationManager = LocationController.sharedInstance.locationManager
    var restaurants: [Restoraunt] = []
    
    var currentPlacemark: CLPlacemark?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        if CLLocationManager.locationServicesEnabled() {
            switch (CLLocationManager.authorizationStatus()) {
            case .denied, .restricted, .notDetermined:
                print("Please Enable location in settings")
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.activityType = .automotiveNavigation
                self.searchNearby()
            default:
                print("Location Services Unavailable.")
            }
        }else{
            print("Services Unavailable.")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemark, error) in
            
            guard let placemark = placemark?.last, let title = placemark.administrativeArea, let postalCode = placemark.postalCode else {return}
            DispatchQueue.main.async {
                self.title = "\(title), LV-\(postalCode)"
                self.currentPlacemark = placemark
            }
            
        })
    }
    
    func searchNearby(){
        locationManager.startUpdatingLocation()
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "restourant"
        
        let search = MKLocalSearch.init(request: request)
        
        search.start { (response, error) in
            guard let response = response else {
                print("Search error: \(String(describing: error))")
                return
            }
            
            for item in response.mapItems{
                guard let name = item.name else {return}
                
                let restaurant = Restoraunt(name: name, placemark: item.placemark)
                self.restaurants.append(restaurant)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.locationManager.stopUpdatingLocation()
            }
        }
        
    }
    

    @IBAction func refreshItemTapped(_ sender: Any) {
        searchNearby()
    }
    // MARK: Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "restaurantCell", for: indexPath)
        
        let restaurant = restaurants[indexPath.row]
        cell.textLabel?.text = restaurant.name
        
        return cell
    }
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToMap"{
            guard let mapVC = segue.destination as? MapViewController, let indexPath = tableView.indexPathForSelectedRow, let current = self.currentPlacemark else {return}
            mapVC.restaurant = restaurants[indexPath.row]
            mapVC.currentPlacemark = current
            
        }
    }
}

