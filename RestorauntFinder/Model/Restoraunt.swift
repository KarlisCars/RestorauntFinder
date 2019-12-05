//
//  Restoraunt.swift
//  RestorauntFinder
//
//  Created by Karlis Cars on 05/12/2019.
//  Copyright © 2019 Karlis Cars. All rights reserved.
//

import Foundation
import MapKit

class Restoraunt{
    let name: String
    let placemark: MKPlacemark
    
    init(name: String, placemark: MKPlacemark) {
        self.name = name
        self.placemark = placemark
    }
}

