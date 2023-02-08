//
//  LocationPickerEx.swift
//  LocationPickerExample
//
//  Created by Salah on 2/19/20.
//  Copyright © 2020 Salah. All rights reserved.
//
import MapKit
extension String{
    var localize_ : String {
        return NSLocalizedString(self, tableName: nil, bundle:Bundle.module ?? Bundle.main, value: "", comment: "")
    }
}
extension UIStoryboard{
    static let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle:Bundle.main)
}
extension UIImage {
    class func bs_frameWorkInit(named:String)->UIImage?{
        return UIImage.init(named: named, in:Bundle.module, compatibleWith: nil);
    }
}
public extension CLLocationCoordinate2D{
    var lp_stringValue:String{
        return "\(self.latitude),\(self.longitude)"
    }
}
extension MKPointOfInterestCategory {
    var title:String {
        switch self {
        case .airport:
        return "airport".localize_
        case .amusementPark:
        return "amusementPark".localize_
        case .aquarium:
        return "aquarium".localize_
        case .atm:
        return "atm".localize_
        case .bakery:
        return "bakery".localize_
        case .bank:
        return "bank".localize_
        case .beach:
        return "beach".localize_
        case .brewery:
        return "brewery".localize_
        case .cafe:
        return "cafe".localize_
        case .campground:
        return "campground".localize_
        case .carRental:
        return "carRental".localize_
        case .evCharger:
        return "evCharger".localize_
        case .fireStation:
        return "fireStation".localize_
        case .fitnessCenter:
        return "fitnessCenter".localize_
        case .foodMarket:
        return "foodMarket".localize_
        case .gasStation:
        return "gasStation".localize_
        case .hospital:
        return "hospital".localize_
        case .hotel:
        return "hotel".localize_
        case .laundry:
        return "laundry".localize_
        case .library:
        return "library".localize_
        case .marina:
        return "marina".localize_
        case .movieTheater:
        return "movieTheater".localize_
        case .museum:
        return "museum".localize_
        case .nationalPark:
        return "nationalPark".localize_
        case .nightlife:
        return "nightlife".localize_
        case .park:
        return "park".localize_
        case .parking:
        return "parking".localize_
        case .pharmacy:
        return "pharmacy".localize_
        case .police:
        return "police".localize_
        case .postOffice:
        return "postOffice".localize_
        case .publicTransport:
        return "publicTransport".localize_
        case .restaurant:
        return "restaurant".localize_
        case .restroom:
        return "restroom".localize_
        case .school:
        return "school".localize_
        case .stadium:
        return "stadium".localize_
        case .store:
        return "store".localize_
        case .theater:
        return "theater".localize_
        case .university:
        return "university".localize_
        case .winery:
        return "winery".localize_
        case .zoo:
        return "zoo".localize_
        default:
        return "".localize_
        }
        return "".localize_
    }
    
   var image:UIImage? {
                switch self {
                case .airport:
                return UIImage.bs_frameWorkInit(named:"ic_airport")
                case .amusementPark:
                return UIImage.bs_frameWorkInit(named:"ic_amusementPark")
                case .aquarium:
                return UIImage.bs_frameWorkInit(named:"ic_aquarium")
                case .atm:
                return UIImage.bs_frameWorkInit(named:"ic_atm")
                case .bakery:
                return UIImage.bs_frameWorkInit(named:"ic_bakery")
                case .bank:
                return UIImage.bs_frameWorkInit(named:"ic_bank")
                case .beach:
                return UIImage.bs_frameWorkInit(named:"ic_beach")
                case .brewery:
                return UIImage.bs_frameWorkInit(named:"ic_brewery")
                case .cafe:
                return UIImage.bs_frameWorkInit(named:"ic_cafe")
                case .campground:
                return UIImage.bs_frameWorkInit(named:"ic_campground")
                case .carRental:
                return UIImage.bs_frameWorkInit(named:"ic_carRental")
                case .evCharger:
                return UIImage.bs_frameWorkInit(named:"ic_evCharger")
                case .fireStation:
                return UIImage.bs_frameWorkInit(named:"ic_fireStation")
                case .fitnessCenter:
                return UIImage.bs_frameWorkInit(named:"ic_fitnessCenter")
                case .foodMarket:
                return UIImage.bs_frameWorkInit(named:"ic_foodMarket")
                case .gasStation:
                return UIImage.bs_frameWorkInit(named:"ic_gasStation")
                case .hospital:
                return UIImage.bs_frameWorkInit(named:"ic_hospital")
                case .hotel:
                return UIImage.bs_frameWorkInit(named:"ic_hotel")
                case .laundry:
                return UIImage.bs_frameWorkInit(named:"ic_laundry")
                case .library:
                return UIImage.bs_frameWorkInit(named:"ic_library")
                case .marina:
                return UIImage.bs_frameWorkInit(named:"ic_marina")
                case .movieTheater:
                return UIImage.bs_frameWorkInit(named:"ic_movieTheater")
                case .museum:
                return UIImage.bs_frameWorkInit(named:"ic_museum")
                case .nationalPark:
                return UIImage.bs_frameWorkInit(named:"ic_nationalPark")
                case .nightlife:
                return UIImage.bs_frameWorkInit(named:"ic_nightlife")
                case .park:
                return UIImage.bs_frameWorkInit(named:"ic_park")
                case .parking:
                return UIImage.bs_frameWorkInit(named:"ic_parking")
                case .pharmacy:
                return UIImage.bs_frameWorkInit(named:"ic_pharmacy")
                case .police:
                return UIImage.bs_frameWorkInit(named:"ic_police")
                case .postOffice:
                return UIImage.bs_frameWorkInit(named:"ic_postOffice")
                case .publicTransport:
                return UIImage.bs_frameWorkInit(named:"ic_publicTransport")
                case .restaurant:
                return UIImage.bs_frameWorkInit(named:"ic_restaurant")
                case .restroom:
                return UIImage.bs_frameWorkInit(named:"ic_restroom")
                case .school:
                return UIImage.bs_frameWorkInit(named:"ic_school")
                case .stadium:
                return UIImage.bs_frameWorkInit(named:"ic_stadium")
                case .store:
                return UIImage.bs_frameWorkInit(named:"ic_store")
                case .theater:
                return UIImage.bs_frameWorkInit(named:"ic_theater")
                case .university:
                return UIImage.bs_frameWorkInit(named:"ic_university")
                case .winery:
                return UIImage.bs_frameWorkInit(named:"ic_winery")
                case .zoo:
                return UIImage.bs_frameWorkInit(named:"ic_zoo")
                default:
                return UIImage.bs_frameWorkInit(named:"ic_")
                }
                return UIImage.bs_frameWorkInit(named:"ic_")
            }
}
extension CLLocationCoordinate2D{
    var locationDescription:String{
        let latitude = String.init(format:"%.6f", self.latitude)
        let longitude = String.init(format:"%.6f", self.longitude)
        return "(\(latitude),\(longitude))";
    }
}
extension Bundle{
    static var module: Bundle? = {
        //firstBundle -> this will used when libarary used in example
        if let firstBundle = Bundle(path: "\(Bundle.main.bundlePath)/Frameworks/LocationPicker.framework/LocationPicker.bundle"),FileManager.default.fileExists(atPath: firstBundle.bundlePath){

    return firstBundle
    }else
        //secondBundle -> this will used when libarary used in pods and add libarary as static libarary
       if let firstBundle = Bundle(path: "\(Bundle.main.bundlePath)/LocationPicker.bundle"),FileManager.default.fileExists(atPath: firstBundle.bundlePath){
    return firstBundle
    }else
        //thiredBundle -> this will used when libarary used in pods
if let secondBundle:Bundle = Bundle(path: "\(Bundle.main.bundlePath)/Frameworks/LocationPicker.framework"),FileManager.default.fileExists(atPath: secondBundle.bundlePath){
            return secondBundle;
    }else
//forthBundle -> this will used when libarary used example mac os
if let secondBundle:Bundle = Bundle(path: "\(Bundle.main.bundlePath)/Contents/Frameworks/LocationPicker.framework"),FileManager.default.fileExists(atPath: secondBundle.bundlePath){
    return secondBundle;
}
      return nil
    }()
}
