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
enum UIBarButtonHiddenItem: Int {
    case locate = 100
    func convert() -> UIBarButtonItem.SystemItem {
        return UIBarButtonItem.SystemItem(rawValue: self.rawValue)!
    }
}

enum LocationType{
case currentLocation(LocationItem)
case customeLocation(LocationItem)
}


open class LocationPickerViewController: UIViewController {
    var span:MKCoordinateSpan = MKCoordinateSpan.init(latitudeDelta: 0.005, longitudeDelta: 0.005)
    private var userLocation:LocationItem?{
        if let coordinate:CLLocationCoordinate2D = self.mapView.userLocation.location?.coordinate{
            return  LocationItem.init(coordinate, title:"CurrentLocation".localize_, subtitle:self.mapView.userLocation.location?.coordinate.locationDescription ?? "", type: nil)
        }
        return nil;
    }
    enum ActionType {
     case center
     case click
        var title:String{
            switch self {
            case .center:
                return "LocationPickerViewController.ActionType.center.title".localize_
            case .click:
                return "LocationPickerViewController.ActionType.click.title".localize_
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
    
    var btnDone: UIButton!{
        if self.navigationController == nil {
            return self.btnPresentDone;
        }else{
            return self.btnNavDone;
        }
    }
    var btnCancel: UIButton!{
        if self.navigationController == nil {
            return self.btnPresentCancel;
        }else{
            return self.btnNavCancel;
        }
    }
    @IBOutlet private weak var btnPresentDone: UIButton!
    @IBOutlet weak var btnNavDone: UIButton!
    @IBOutlet private weak var btnPresentCancel: UIButton!
    @IBOutlet private weak var btnNavCancel: UIButton!
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
            if let selectedLocation:LocationItem=self.selectedLocation,let cordinate:CLLocationCoordinate2D = selectedLocation.coordinate{
            self.setRegion(cordinate)
            self.addAnotaion(cordinate)
                nearlyPlace(self.searchView.text);
            }
            }
        }
    }
    open override func viewDidLoad() {
        super.viewDidLoad();

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
        setupLocalization();
    }
    func setupLocalization(){
        self.btnDone.setTitle("Done".localize_, for: .normal);
        self.btnCancel.setTitle("Cancel".localize_, for: .normal);
        self.searchView.placeHolder="Search".localize_
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
    
    @IBAction private func btnNavCancel(_ sender: Any) {
    self.dismiss(animated: true, completion: {
    self.cancel?();
    })
    }
    @IBAction private func btnPresentCancel(_ sender: Any) {
    self.dismiss(animated: true, completion: {
    self.cancel?();
    })
    }
    @IBAction private func btnPresentDone(_ sender: Any) {
    didTapDoneButton(doneButton:true);
    }
    @IBAction func btnNavDone(_ sender: Any) {
    didTapDoneButton(doneButton:true);
    }
    public static func initPicker(_ selectedLocation:LocationItem?=nil,_ span:MKCoordinateSpan?=nil)->LocationPickerViewController?{
        let storyboard:UIStoryboard = UIStoryboard.init(name: "LocationPicker", bundle:Bundle.module)
        if let vc = storyboard.instantiateViewController(withIdentifier:"LocationPickerViewController") as? LocationPickerViewController{
            vc.selectedLocation=selectedLocation;
        if let span:MKCoordinateSpan=span{
            vc.span = span;
        }
        return vc;
    }
        return nil;
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
            
            self.success?(LocationItem.init(self.mapView.centerCoordinate, title: "", subtitle:"", type: nil), doneButton)
        }
    }
}

// MARK: - MKMapView delegate

extension LocationPickerViewController: MKMapViewDelegate {
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
        }else{
    self.btnDone.isHidden=false;
    self.updateCoordinate(true);
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
            cell.img?.image=UIImage.bs_frameWorkInit(named:"ic_currentLocation");
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
                if let currentLocation:LocationItem = self.userLocation,let coordinate:CLLocationCoordinate2D = currentLocation.coordinate{
                    self.pointAnnotation?.coordinate=coordinate;
                    self.mapView.setCenter(coordinate, animated: true)
                    self.didTapDoneButton(currentLocation,doneButton:false);
                    }
                break;
             case .customeLocation(let location):
                if let coordinate:CLLocationCoordinate2D = location.coordinate{
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
                self.objects.append(.customeLocation(LocationItem.init(object.placemark.coordinate, title: object.name ?? "", subtitle: object.placemark.title ?? self.mapView.userLocation.location?.coordinate.locationDescription ?? "", type: object.pointOfInterestCategory)
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
    func updateCoordinate(_ refreshPlaces:Bool){
        if self.actionType == .click {
            
        }else
        if self.actionType == .center {
        self.pointAnnotation?.coordinate = mapView.region.center
        }
        if refreshPlaces {
        self.nearlyPlace(self.searchView.text);
        }
    }
    @objc func longTap(sender: UIGestureRecognizer){
            let locationInView = sender.location(in: mapView)
            let locationOnMap = mapView.convert(locationInView, toCoordinateFrom: mapView)
            self.pointAnnotation?.coordinate = locationOnMap
            self.btnDone.isHidden=false;
            self.nearlyPlace(self.searchView.text);

    }
}

