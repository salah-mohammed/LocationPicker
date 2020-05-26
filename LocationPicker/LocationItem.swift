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
    public var coordinate:CLLocationCoordinate2D?
    public var type:MKPointOfInterestCategory?

    public init(_ coordinate:CLLocationCoordinate2D,title:String,subtitle:String,type:MKPointOfInterestCategory?) {
        super.init()
        self.coordinate = coordinate;
        self.title = title;
        self.subtitle = subtitle;
        self.type=type
    }
}
