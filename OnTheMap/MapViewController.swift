//
//  FirstViewController.swift
//  OnTheMap
//
//  Created by Jean-Marc Kampol Mieville on 12/26/2559 BE.
//  Copyright © 2559 Jean-Marc Kampol Mieville. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    //Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    //Variables/Constants
    
    let reuseId = "pin"
    var selectedView: MKAnnotationView?
    var tapGesture: UITapGestureRecognizer!
    
    //Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(calloutTapped))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ParseAPI.getMapData(callback: { (result) -> Void in
            if result == Result.OK {
                DispatchQueue.main.async {
                    self.studentOnMapInformation()
                }
            } else {
                self.presentAlert(title: "There was an error", message: Messages.networkError, actionTitle: "Return")
            }
        })
    }

    //Private methods
    
    // Get the student info
    func studentOnMapInformation() {
        let students = StudentLocationModel.student
        var pinnedLocations = [MKPointAnnotation]()
        
        // Reset Pins on the Map
        DispatchQueue.main.async {
            for pinnedLocation in pinnedLocations {
                self.mapView.removeAnnotation(pinnedLocation)
            }
        }
        
        // Preparing Student information for Annotation (Pin on map)
        for student in students {
            let latitude = CLLocationDegrees(student.latitudeKey)
            let longitude = CLLocationDegrees(student.longitudeKey)
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let firstName = student.firstNameKey
            let lastName = student.lastNameKey
            let mediaLink = student.mediaURLKey
            let pinOnMapAnnotation = MKPointAnnotation()
            pinOnMapAnnotation.coordinate = coordinate
            pinOnMapAnnotation.title = "\(firstName) \(lastName)"
            pinOnMapAnnotation.subtitle = mediaLink
            
            // Add student pin into Array of pinnedLocation
            pinnedLocations.append(pinOnMapAnnotation)
        }
        // Get the info asynchronously then put on the map
        DispatchQueue.main.async {
            self.mapView.addAnnotations(pinnedLocations)
        }
    }
    // View Annotation
    func mapView(_ mapView: MKMapView, viewforAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    // Note: RightCallout for some reason didnt work
    // Using tap gesture on selected annotation view as an alternative
    // Memorize view
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        view.addGestureRecognizer(tapGesture)
        selectedView = view
    }
    // Forget view
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        selectedView = nil
        view.removeGestureRecognizer(tapGesture)
    }
    // Click to URL if URL is proper
    func calloutTapped(sender: MapViewController) {
        let app = UIApplication.shared
        if let toOpen = NSURL(string: (selectedView?.annotation?.subtitle!)!) {
            if app.canOpenURL(toOpen as URL) == true {
                app.open(toOpen as URL, options: [:], completionHandler: nil)
            }
        }
    }
    //Delegate methods
    //Extensions
}

