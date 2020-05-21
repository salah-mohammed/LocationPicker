//
//  LocationItem.swift
//  LocationPickerExample
//
//  Created by Salah on 2/19/20.
//  Copyright © 2020 Salah. All rights reserved.
//

import UIKit
import MapKit
public class LocationItem:NSObject {
    public var title:String?
    public var subtitle:String?
    public var location:CLLocationCoordinate2D?
    public var type:MKPointOfInterestCategory?

    public init(location:CLLocationCoordinate2D,title:String,subtitle:String,type:MKPointOfInterestCategory?) {
        super.init()
        self.location = location;
        self.title = title;
        self.subtitle = subtitle;
        self.type=type
    }
}
