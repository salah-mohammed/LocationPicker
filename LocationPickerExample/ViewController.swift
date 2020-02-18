//
//  ViewController.swift
//  LocationPickeerExample
//
//  Created by Salah on 1/21/20.
//  Copyright © 2020 Salah. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
class ViewController: UIViewController {
    @IBOutlet weak var btnPresent: UIButton!
    @IBOutlet weak var btnPush: UIButton!
    @IBOutlet weak var lblPushCoordinate: UILabel!
    @IBOutlet weak var lblPushAddress: UILabel!
    @IBOutlet weak var lblPresentCoordinate: UILabel!
    @IBOutlet weak var lblPresentAddress: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func btnPush(_ sender: Any) {
   if let vc:LocationPickerViewController = LocationPickerViewController.initPicker(LocationItem.init(location:CLLocationCoordinate2D.init(latitude:31.210566, longitude:29.912188), title:"", subtitle:"", type: nil), nil){
       vc.success={ (object,doneButton) in
           if doneButton {
               vc.dismiss(animated: true, completion: nil);
           }
           self.lblPushCoordinate.text="\(Int(object.location?.latitude ?? 0)),\(Int(object.location?.longitude ?? 0))"
           self.lblPushAddress.text=object.title ?? "";
       }
       vc.failure={ (error) in
       }
       vc.cancel={
           vc.dismiss(animated: true, completion: nil);
       }
     //  self.present(vc, animated: true, completion: nil);
    self.navigationController?.pushViewController(vc, animated: true);
   }
    }
    @IBAction func btnPresent(_ sender: Any) {
        if let vc:LocationPickerViewController = LocationPickerViewController.initPicker(LocationItem.init(location:CLLocationCoordinate2D.init(latitude:31.210566, longitude:29.912188), title:"", subtitle:"", type: nil), nil){
            vc.success={ (object,doneButton) in
                if doneButton {
                    vc.dismiss(animated: true, completion: nil);
                }
                self.lblPresentCoordinate.text="\(Int(object.location?.latitude ?? 0)),\(Int(object.location?.longitude ?? 0))"
                self.lblPresentAddress.text=object.title ?? "";
            }
            vc.failure={ (error) in
            }
            vc.cancel={
                vc.dismiss(animated: true, completion: nil);
            }
          //  self.present(vc, animated: true, completion: nil);
            self.navigationController?.present(vc, animated: true, completion: nil);
        }
    }
}

