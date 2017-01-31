//
//  PostViewController.swift
//  OnTheMap
//
//  Created by Jean-Marc Kampol Mieville on 12/31/2559 BE.
//  Copyright © 2559 Jean-Marc Kampol Mieville. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class PostViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate {
    
    //Outlets
    
    // Text label
    @IBOutlet weak var textLabelTop: UILabel!
    @IBOutlet weak var textLabelMid: UILabel!
    @IBOutlet weak var textLabelBot: UILabel!
    @IBOutlet weak var textLabelForUrl: UILabel!
    @IBOutlet weak var indicativeLabel: UILabel!
    
    // Textfields
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    
    // MapView for location and URL
    @IBOutlet weak var mapViewForLocation: MKMapView!
    
    // Btn Outlet
    @IBOutlet weak var submitBtnOutlet: UIButton!
    
    
    // Actions
    @IBAction func doCancel(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doFindOnMap(_ sender: Any) {
        guard let text = locationTextField.text else{
            return
        }
        if text.characters.count == 0 {
            indicativeLabel.text = "Please fill in below textfield"
        } else {
            dismissKeyboard()
            getLocationOnMap()
            indicativeLabel.text = "Loading"
        }
    }
    
    @IBAction func submitLocationAndURL(_ sender: Any) {
        guard connectedToNetwork() == true else {
            presentAlert(title: "No Internet", message: Messages.noInternet, actionTitle: "Return")
            return
        }
        
        guard coordinate != nil, urlTextField != nil else {
            return
        }
        
        User.latitude = (self.coordinate?.location?.coordinate.latitude)!
        User.longitude = (self.coordinate?.location?.coordinate.longitude)!
        User.mediaURL = self.urlTextField.text!
        self.textLabelForUrl.text = "Loading"
        dismissKeyboard()
        
        ParseAPI.postNewStudentLocation{ (data, response, error) in
            DispatchQueue.main.async {
                self.showSpinner().hide()
                if error != nil {
                    self.textLabelForUrl.text = "Posting user location failed, try again"
                    self.presentAlert(title: "Cannot Post", message: Messages.cannotPost, actionTitle: "Return")
                } else {
                    if data != nil {
                        self.textLabelForUrl.text = "Successfully posted your info!"
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        self.textLabelForUrl.text = "Posting user location failed, try again"
                        self.presentAlert(title: "Post Failed", message: Messages.failedToPost, actionTitle: "Return")
                    }
                }
            }
        }
    }
    
    //Variables/Constants
    let identifier = "pin"
    var location: CLLocation?
    var mapString: String = ""
    var coordinate : CLPlacemark?

    
    //Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTextField.delegate = self
        urlTextField.delegate = self
        mapViewForLocation.delegate = self
        switchToSubMit(a: false)
    }
    
    //Private methods
    // Show map
    func showMap() {
        guard let myPosition = self.coordinate else {
            return
        }
        let place = MKPlacemark(placemark: myPosition)
        self.mapViewForLocation.addAnnotation(place)
        let region = MKCoordinateRegionMakeWithDistance((place.location?.coordinate)!, 5000.0, 7000.0)
        mapViewForLocation.setRegion(region, animated: true)
    }
    
    func getLocationOnMap() {
        guard let locationtext = locationTextField.text else {
            return
        }
        let spin = showSpinner()
        User.mapString = locationtext
        CLGeocoder().geocodeAddressString(locationtext) { (placemarks, error) in
            if error != nil {
                print("address not found")
                self.indicativeLabel.text = "Address not found, please try again"
                self.switchToSubMit(a: false)
                self.presentAlert(title: "Address not found", message: Messages.addressNotFound, actionTitle: "Return")

            } else if placemarks!.count > 0 {
                let placemark = placemarks![0] as CLPlacemark
                self.coordinate = placemark
                self.showMap()
                self.switchToSubMit(a: true)
                print("This is the landmark")
                
            } else {
                self.indicativeLabel.text = "Cannot find placemarks as requested"
                print("Cannot find placemarks as requested")
                self.switchToSubMit(a: false)
                self.presentAlert(title: "Address not found", message: Messages.addressNotFound, actionTitle: "Return")
            }
            DispatchQueue.main.async {
                spin.hide()
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // After clicking on Find On Map -> change layout appearance to show Submit layout
    func switchToSubMit(a: Bool) {
        mapViewForLocation.isHidden = !a
        urlTextField.isHidden = !a
        textLabelTop.isHidden = a
        textLabelMid.isHidden = a
        textLabelBot.isHidden = a
        textLabelForUrl.isHidden = !a
        submitBtnOutlet.isHidden = !a

    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 20000, 20000)
        mapViewForLocation.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(mapView: MKMapView, viewforAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        var pinView: MKPinAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
            dequeuedView.annotation = annotation
            pinView = dequeuedView
        } else {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            pinView.pinTintColor = UIColor.red
            pinView.canShowCallout = true
            pinView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return pinView
    }
}
