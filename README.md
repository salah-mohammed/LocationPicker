# LocationPicker

GeneralKit  It was built  for every application that displays data in UITableView and UICollectionView from the network or from local data, support network management in Very clean code.

# Features

* It is a Data management Library  support HTTP networking.
* Data display management in UITableView and UICollectionView,In an easy and simple way and with the least possible code by GeneralKit tools.
* Pagination.
* Support UIKit and SwiftUI(WithExample).
* Very clean code.
* Tools to present data in UITableView and UICollectionView.
* Placeholder for UITableView  and UICollectionView.
* Single,Multi and Single Section selection  for UITableView  and UICollectionView.
* Upload File / Data / Stream / MultipartFormData.
* URL / JSON Parameter Encoding.
* You can develop a project with very clear code
* Swift Concurrency Support Back to iOS 13.


# Requirements
* IOS 13+ 
* Swift 5+
* OSX 10.15+ 



# Pod install
```ruby
pod 'LocationPicker',:git => "https://github.com/salah-mohammed/LocationPicker.git"
 
```
# How used (Webservice configuration):
- Push 
```swift
   if let vc:LocationPickerViewController = LocationPickerViewController.initPicker(LocationItem.init(CLLocationCoordinate2D.init(latitude:31.210566, longitude:29.912188), title:"", subtitle:"", type: nil), nil){
       vc.success={ (object,doneButton) in
           if doneButton {
               vc.dismiss(animated: true, completion: nil);
           }
           self.lblPushCoordinate.text="\(Int(object.coordinate?.latitude ?? 0)),\(Int(object.coordinate?.longitude ?? 0))"
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
```
- Present 
```swift
        if let vc:LocationPickerViewController = LocationPickerViewController.initPicker(LocationItem.init(CLLocationCoordinate2D.init(latitude:31.210566, longitude:29.912188), title:"", subtitle:"", type: nil), nil){
            vc.success={ (object,doneButton) in
                if doneButton {
                    vc.dismiss(animated: true, completion: nil);
                }
                self.lblPresentCoordinate.text="\(Int(object.coordinate?.latitude ?? 0)),\(Int(object.coordinate?.longitude ?? 0))"
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
```


#Result:

# Developer's information to communicate

- salahalimohamed1995@gmail.com
- https://www.facebook.com/salah.shaker.7
- +201096710204 (whatsApp And PhoneNumber)
- https://www.linkedin.com/in/salah-mohamed-676b6a17a (Linkedin)
- https://www.upwork.com/freelancers/~01d5d99dadac372b6d (Upwork)
