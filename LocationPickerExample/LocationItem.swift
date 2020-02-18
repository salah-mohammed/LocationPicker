//
//  LocationItem.swift
//  LocationPickerExample
//
//  Created by Salah on 2/19/20.
//  Copyright © 2020 Salah. All rights reserved.
//

import UIKit
import MapKit
open class LocationItem:NSObject {
    var title:String?
    var subtitle:String?
    var location:CLLocationCoordinate2D?
    var type:MKPointOfInterestCategory?

    init(location:CLLocationCoordinate2D,title:String,subtitle:String,type:MKPointOfInterestCategory?) {
        super.init()
        self.location = location;
        self.title = title;
        self.subtitle = subtitle;
        self.type=type
    }
}
