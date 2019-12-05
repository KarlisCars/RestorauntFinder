//
//  LocationControllers.swift
//  RestorauntFinder
//
//  Created by Karlis Cars on 05/12/2019.
//  Copyright © 2019 Karlis Cars. All rights reserved.
//

import Foundation
import CoreLocation


class LocationController{
    static let sharedInstance = LocationController()
    
    var locationManager: CLLocationManager
    
    init() {
        self.locationManager = CLLocationManager()
    }
}
