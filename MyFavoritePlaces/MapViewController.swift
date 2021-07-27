//
//  MapViewController.swift
//  MyFavoritePlaces
//
//  Created by Eʟᴅᴀʀ Tᴇɴɢɪᴢᴏᴠ on 27.07.2021.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    var currentPlace: Place!
    let annotationIdentifier = "annotationIdentifier"
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocation()
        mapView.delegate = self
    }
    
    private func setupLocation() {
        guard let location = currentPlace.location else { return }
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { [weak self] placemarks, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let placemarks = placemarks else { return }
            let placemark = placemarks.first
            
            let annotation = MKPointAnnotation()
            annotation.title = self?.currentPlace.name
            annotation.subtitle = self?.currentPlace.type
            
            guard let placemarkLocation = placemark?.location else { return }
            annotation.coordinate = placemarkLocation.coordinate
            
            self?.mapView.showAnnotations([annotation], animated: true)
            self?.mapView.selectAnnotation(annotation, animated: true)
        }
        
        
    }
    
    @IBAction func cancellAction() {
        dismiss(animated: true)
    }
    
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.canShowCallout = true
        }
        
        if let data = currentPlace.image {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            imageView.layer.cornerRadius = 10
            imageView.clipsToBounds = true
            imageView.image = UIImage(data: data)
            annotationView?.rightCalloutAccessoryView = imageView
        }
        return annotationView
    }
}
