//
//  MapViewController.swift
//  RestorauntFinder
//
//  Created by Karlis Cars on 05/12/2019.
//  Copyright © 2019 Karlis Cars. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var restaurant: Restoraunt?
    var currentPlacemark: CLPlacemark?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        setUpMapUI()

        
        
    }
    
    func setUpMapUI(){
        guard let restaurant = self.restaurant else {return}
        self.title = "\(restaurant.name)"
        centerMapOnLocation(coordinate: restaurant.placemark.coordinate)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = restaurant.placemark.coordinate
        mapView.addAnnotation(annotation)
    
    }

    func centerMapOnLocation(coordinate: CLLocationCoordinate2D){
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
        mapView.setRegion(region, animated: true)
    }
    
    func showDirection(){
        
        guard let restaurant = self.restaurant,
            let currentPLacemark = self.currentPlacemark,
            let currentCoordiante = self.currentPlacemark?.location?.coordinate else {return}
        
        let request = MKDirections.Request()
        
        let currentMKPlacemark = MKPlacemark(coordinate: currentCoordiante, addressDictionary: currentPLacemark.areasOfInterest as! [String: Any]?)
        
        request.source = MKMapItem(placemark: currentMKPlacemark)
        request.destination = MKMapItem(placemark: restaurant.placemark)
    }

}
