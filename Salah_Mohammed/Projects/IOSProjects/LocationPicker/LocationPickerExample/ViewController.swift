//
//  ViewController.swift
//  LocationPickeerExample
//
//  Created by Salah on 1/21/20.
//  Copyright © 2020 Salah. All rights reserved.
//

import UIKit
class ViewController: UIViewController {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnPresent: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func btnPresent(_ sender: Any) {
        if let vc:LocationPickerViewController = LocationPickerViewController.initPicker(){
            vc.success={ (object,doneButton) in
                if doneButton {
                    vc.dismiss(animated: true, completion: nil);
                }
                self.lblTitle.text="\(object.title ?? ""),\(Int(object.location?.latitude ?? 0)),\(Int(object.location?.longitude ?? 0))"
            }
            vc.failure={ (error) in
            }
            vc.cancel={
                vc.dismiss(animated: true, completion: nil);
            }
            self.present(vc, animated: true, completion: nil);
        }
    }
}

