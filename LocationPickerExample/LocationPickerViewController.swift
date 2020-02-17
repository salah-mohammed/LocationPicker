//
//  LocationPickerViewController.swift
//  LocationPickeer
//
//  Created by Salah on 1/22/20.
//  Copyright © 2020 Salah. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
extension String{
    var localize_ : String {
        return NSLocalizedString(self, comment: "")
    }
}
enum UIBarButtonHiddenItem: Int {
    case locate = 100
    func convert() -> UIBarButtonItem.SystemItem {
        return UIBarButtonItem.SystemItem(rawValue: self.rawValue)!
    }
}

extension UIBarButtonItem {
    convenience init(barButtonHiddenItem item:UIBarButtonHiddenItem, target: AnyObject?, action: Selector) {
        self.init(barButtonSystemItem: item.convert(), target:target, action: action)
    }
}



extension UIStoryboard{
    static let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle:Bundle.main)
}
enum LocationType{
case currentLocation(LocationItem)
case customeLocation(LocationItem)
}
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
open class LocationPickerViewController: UIViewController {
    var span:MKCoordinateSpan = MKCoordinateSpan.init(latitudeDelta: 0.005, longitudeDelta: 0.005)
    private var userLocation:LocationItem?{
        if let coordinate:CLLocationCoordinate2D = self.mapView.userLocation.location?.coordinate{
            return  LocationItem.init(location:coordinate, title:"Current Location", subtitle:self.mapView.userLocation.location?.coordinate.locationDescription ?? "", type: nil)
        }
        return nil;
    }
    enum ActionType {
     case center
     case click
        var title:String{
            switch self {
            case .center:
                return "center"
            case .click:
                return "click"
            }
        }
    }
    var actionType:ActionType = .click{
        didSet{
            if self.actionType == .click {
                if tapGesture == nil {
            self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(longTap))
                mapView.addGestureRecognizer(self.tapGesture!)
            }
            }else
            if self.actionType == .center {
                if let tapGesture:UITapGestureRecognizer = self.tapGesture{
                    self.mapView.removeGestureRecognizer(tapGesture);
                    self.tapGesture=nil;
                    if let coordinate:CLLocationCoordinate2D = self.pointAnnotation?.coordinate  {
                        self.setRegion(coordinate);
                    }
                }
            }
        }
    }
    public typealias successClosure = (LocationItem,Bool) -> Void
    public typealias failureClosure = (NSError) -> Void
    public typealias cancelClosure = () -> Void
    
    @IBOutlet private weak var btnDone: UIButton!
    @IBOutlet private weak var btnCancel: UIButton!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet private weak var searchView: SearchView!
    @IBOutlet private weak var segmentedControlActionType: UISegmentedControl!

    fileprivate var pointAnnotation: MKPointAnnotation?
    fileprivate let locationManager: CLLocationManager = CLLocationManager()
    var tapGesture:UITapGestureRecognizer?
    open var success: successClosure?
    open var failure: failureClosure?
    open var cancel: cancelClosure?
    fileprivate var isInitialized = false
    var searchMode:Bool=false;
    var objects:[LocationType]=[LocationType]();

    private var selectedLocation:LocationItem?{
        didSet{
            if self.isViewLoaded{
            if let selectedLocation:LocationItem=self.selectedLocation,let cordinate:CLLocationCoordinate2D = selectedLocation.location{
            self.setRegion(cordinate)
            self.addAnotaion(cordinate)
                nearlyPlace(self.searchView.text);
            }
            }
        }
    }
    open override func viewDidLoad() {
        super.viewDidLoad();
      /*  let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                             target: self,
                                             action: #selector(LocationPickerViewController.didTapDoneButton))
 */
  //      self.navigationItem.rightBarButtonItem = doneButtonItem
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.mapView.showsUserLocation = true
        self.mapView.delegate = self
        self.searchView.searchHandler = {
        self.search(true);
        }
        self.searchView.endEditing = {
            self.search(false);
        }
        self.searchView.didBeginHandler = {
            self.searchMode=true;
        }
        self.btnDone.isHidden=true;
        let actionType:ActionType = self.actionType;
        self.actionType=actionType;
        self.segmentedControlActionType.setTitle(ActionType.click.title, forSegmentAt:0);
        self.segmentedControlActionType.setTitle(ActionType.center.title, forSegmentAt:1);
       
        if let selectedLocation:LocationItem=self.selectedLocation{
            self.selectedLocation=selectedLocation;
        }
    }
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
        self.headerViewHeight(UIScreen.main.bounds.height*0.72);
    }
    @IBAction private func segmentedControlActionType(_ sender: Any) {
        if segmentedControlActionType.selectedSegmentIndex == 0 {
            self.actionType = .click;
        }
        else if segmentedControlActionType.selectedSegmentIndex == 1{
            self.actionType = .center;
        }
    }
    @IBAction private func btnCancel(_ sender: Any) {
    self.dismiss(animated: true, completion: {
    self.cancel?();
    })
    }
    @IBAction private func btnDone(_ sender: Any) {
        didTapDoneButton(doneButton:true);
    }
    public static func initPicker(_ selectedLocation:LocationItem?=nil,_ span:MKCoordinateSpan?=nil)->LocationPickerViewController?{
            let storyboard = UIStoryboard(name: "Main",bundle: Bundle.init(for:LocationPickerViewController.self));
            let  vc = storyboard.instantiateViewController(withIdentifier:"LocationPickerViewController") as? LocationPickerViewController;
        vc?.selectedLocation=selectedLocation;
        if let span:MKCoordinateSpan=span{
        vc?.span = span;
        }
        return vc;
    }
}
internal extension LocationPickerViewController {

    @objc func didTapDoneButton(_ locationItem:LocationItem?=nil,doneButton:Bool=false) {
        if let locationItem:LocationItem=locationItem {
            self.success?(locationItem, doneButton)

        }else{
            guard CLLocationCoordinate2DIsValid(self.mapView.centerCoordinate) else {
                self.failure?(NSError(domain: "LocationPickerControllerErrorDomain",
                    code: 0,
                    userInfo: [NSLocalizedDescriptionKey: "Invalid coordinate"]))
                return
            }
            
            self.success?(LocationItem.init(location: self.mapView.centerCoordinate, title: "", subtitle:"", type: nil), doneButton)
        }
    }
}

// MARK: - MKMapView delegate

extension LocationPickerViewController: MKMapViewDelegate {
    func updateCoordinate(_ refreshPlaces:Bool){
        if self.actionType == .click {
            
        }else
        if self.actionType == .center {
        self.pointAnnotation?.coordinate = mapView.region.center
            if refreshPlaces {
        self.nearlyPlace(self.searchView.text);
            }
        }
    }
    public func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        updateCoordinate(true);
    }
    public func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
       updateCoordinate(false);
    }
    public func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
    }
    public func mapViewWillStartLoadingMap(_ mapView: MKMapView){
    self.activityIndicatorView.startAnimating();
        if self.pointAnnotation?.coordinate == nil {
    self.btnDone.isHidden=true;
        }
    }
    public func mapViewWillStartLocatingUser(_ mapView: MKMapView) {
    self.activityIndicatorView.startAnimating();
        if self.pointAnnotation?.coordinate == nil {
    self.btnDone.isHidden=true;
        }
    }
    public func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
    self.activityIndicatorView.stopAnimating();
        if self.pointAnnotation?.coordinate == nil {
    self.btnDone.isHidden=true;
        }
    }

    public func mapView(_ mapView: MKMapView, didFailToLocateUserWithError error: Error) {
        self.activityIndicatorView.stopAnimating();
    }
    public func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        self.activityIndicatorView.stopAnimating();
//        if self.actionType == .center{
//        self.btnDone.isHidden=false;
//        if self.searchMode == false {
//        self.nearlyPlace(self.searchView.text);
//        }
//        }else
//        if self.actionType == .click{
//
//        }
        
    }
    public func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {

    }
    @objc func longTap(sender: UIGestureRecognizer){
            let locationInView = sender.location(in: mapView)
            let locationOnMap = mapView.convert(locationInView, toCoordinateFrom: mapView)
            self.pointAnnotation?.coordinate = locationOnMap
            self.btnDone.isHidden=false;
            self.nearlyPlace(self.searchView.text);

    }
}


// MARK: - CLLocationManager delegate

extension LocationPickerViewController: CLLocationManagerDelegate {

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break
        case .authorizedAlways, .authorizedWhenInUse:
            break
        }
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last, !self.isInitialized,self.selectedLocation == nil else {
            return
        }
      
        self.locationManager.stopUpdatingLocation()

        self.setRegion(newLocation.coordinate)
        self.addAnotaion(newLocation.coordinate)
        self.isInitialized = true
    }
}
extension LocationPickerViewController: UITableViewDelegate,UITableViewDataSource {
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:LocationTableViewCell = tableView.dequeueReusableCell(withIdentifier:"LocationTableViewCell") as! LocationTableViewCell;
        switch objects[indexPath.row] {
   
        case .currentLocation(let currentLocation):
            cell.lblTitle.text = currentLocation.title
            cell.lblSubtitle.text = currentLocation.subtitle;
            break;
        case .customeLocation(let location):
            cell.lblTitle.text=location.title
            cell.lblSubtitle.text=location.subtitle;
            cell.img.image=location.type?.image;
            break;
        @unknown default:
            break;
        }

        return cell;
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count;
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 90
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
             switch objects[indexPath.row] {
             case .currentLocation:
                if let currentLocation:LocationItem = self.userLocation,let coordinate:CLLocationCoordinate2D = currentLocation.location{
                    self.pointAnnotation?.coordinate=coordinate;
                    self.mapView.setCenter(coordinate, animated: true)
                    self.didTapDoneButton(currentLocation,doneButton:false);
                    }
                break;
             case .customeLocation(let location):
                if let location:LocationItem = location,let coordinate:CLLocationCoordinate2D = location.location{
                    self.pointAnnotation?.coordinate=coordinate;
                self.mapView.setCenter(coordinate, animated: true)
                }
                self.didTapDoneButton(doneButton:false);
                 break;
             @unknown default:
                 break;
             }
        tableView.deselectRow(at: indexPath, animated: true);
    }
}
extension LocationPickerViewController{
    private func search(_ hideKeyBoad:Bool){
        if self.searchView.text?.count == 0 {
            self.searchMode=false;
        }else{
            self.searchMode=true;
        }
        self.nearlyPlace(self.searchView.text);
        if hideKeyBoad{
        self.searchView.txtSearch.resignFirstResponder();
        }
    }
    private func nearlyPlace(_ searchText:String?=nil){
        activityIndicatorView.startAnimating();
        let localSearchRequest = MKLocalSearch.Request()
        localSearchRequest.naturalLanguageQuery = searchText
        localSearchRequest.resultTypes = [MKLocalSearch.ResultType.pointOfInterest,MKLocalSearch.ResultType.address]
        if self.actionType == .click , let pointAnnotation:MKPointAnnotation = pointAnnotation {
            localSearchRequest.region=MKCoordinateRegion(center:pointAnnotation.coordinate, span: span)
        }
        else
        if self.actionType == .center {
           localSearchRequest.region=self.mapView.region;
        }
        let localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { (response:MKLocalSearch.Response?, error) in
        self.objects.removeAll();
        self.activityIndicatorView.stopAnimating();
            if let locationItem:LocationItem = self.userLocation{
                self.objects.append(.currentLocation(locationItem));
            }
        if let mapItems:[MKMapItem] = response?.mapItems,mapItems.count >= 0  {
            for object in response?.mapItems ?? [] {
                self.objects.append(.customeLocation(LocationItem.init(location: object.placemark.coordinate, title: object.name ?? "", subtitle: object.placemark.title ?? self.mapView.userLocation.location?.coordinate.locationDescription ?? "", type: object.pointOfInterestCategory)
));
            }
        }else
        if error == nil{
            print("error==nil")
        }else
        if response?.mapItems == nil {
                print("mapItems==nil")
        }
           self.tableView.reloadData();
        }
    }
    private func headerViewHeight(_ height:CGFloat){
        if let header = tableView.tableHeaderView {
             header.frame.size.height = height
         }
    }
    func addAnotaion(_ coordinate:CLLocationCoordinate2D){
        if self.pointAnnotation == nil {
        self.pointAnnotation = MKPointAnnotation()
        }
        self.pointAnnotation?.coordinate = coordinate
        if let pointAnnotation:MKPointAnnotation = self.pointAnnotation{
        self.mapView.addAnnotation(pointAnnotation)
        }
    }
    func setRegion(_ coordinate:CLLocationCoordinate2D){
        let centerCoordinate = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude)
        let region = MKCoordinateRegion(center: centerCoordinate, span: span)
        self.mapView.setRegion(region, animated: true)
    }
}

extension CLLocationCoordinate2D{
    var locationDescription:String{
        let latitude = String.init(format:"%.6f", self.latitude)
        let longitude = String.init(format:"%.6f", self.longitude)
        return "(\(latitude),\(longitude))";
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
                return UIImage.init(named:"ic_airport")
                case .amusementPark:
                return UIImage.init(named:"ic_amusementPark")
                case .aquarium:
                return UIImage.init(named:"ic_aquarium")
                case .atm:
                return UIImage.init(named:"ic_atm")
                case .bakery:
                return UIImage.init(named:"ic_bakery")
                case .bank:
                return UIImage.init(named:"ic_bank")
                case .beach:
                return UIImage.init(named:"ic_beach")
                case .brewery:
                return UIImage.init(named:"ic_brewery")
                case .cafe:
                return UIImage.init(named:"ic_cafe")
                case .campground:
                return UIImage.init(named:"ic_campground")
                case .carRental:
                return UIImage.init(named:"ic_carRental")
                case .evCharger:
                return UIImage.init(named:"ic_evCharger")
                case .fireStation:
                return UIImage.init(named:"ic_fireStation")
                case .fitnessCenter:
                return UIImage.init(named:"ic_fitnessCenter")
                case .foodMarket:
                return UIImage.init(named:"ic_foodMarket")
                case .gasStation:
                return UIImage.init(named:"ic_gasStation")
                case .hospital:
                return UIImage.init(named:"ic_hospital")
                case .hotel:
                return UIImage.init(named:"ic_hotel")
                case .laundry:
                return UIImage.init(named:"ic_laundry")
                case .library:
                return UIImage.init(named:"ic_library")
                case .marina:
                return UIImage.init(named:"ic_marina")
                case .movieTheater:
                return UIImage.init(named:"ic_movieTheater")
                case .museum:
                return UIImage.init(named:"ic_museum")
                case .nationalPark:
                return UIImage.init(named:"ic_nationalPark")
                case .nightlife:
                return UIImage.init(named:"ic_nightlife")
                case .park:
                return UIImage.init(named:"ic_park")
                case .parking:
                return UIImage.init(named:"ic_parking")
                case .pharmacy:
                return UIImage.init(named:"ic_pharmacy")
                case .police:
                return UIImage.init(named:"ic_police")
                case .postOffice:
                return UIImage.init(named:"ic_postOffice")
                case .publicTransport:
                return UIImage.init(named:"ic_publicTransport")
                case .restaurant:
                return UIImage.init(named:"ic_restaurant")
                case .restroom:
                return UIImage.init(named:"ic_restroom")
                case .school:
                return UIImage.init(named:"ic_school")
                case .stadium:
                return UIImage.init(named:"ic_stadium")
                case .store:
                return UIImage.init(named:"ic_store")
                case .theater:
                return UIImage.init(named:"ic_theater")
                case .university:
                return UIImage.init(named:"ic_university")
                case .winery:
                return UIImage.init(named:"ic_winery")
                case .zoo:
                return UIImage.init(named:"ic_zoo")
                default:
                return UIImage.init(named:"ic_")
                }
                return UIImage.init(named:"ic_")
            }
}
