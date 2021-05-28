//
//  AreaDetailViewController.swift
//  TermProject
//
//  Created by kpugame on 2021/05/25.
//

import UIKit
import MapKit
import Contacts

class AreaDetailViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var areaNameLabel: UILabel!
    @IBOutlet weak var telephoneLabel: UILabel!
    @IBOutlet weak var detailAddressLabel: UILabel!
    @IBOutlet weak var map: MKMapView!
    
    let regionRadius: CLLocationDistance = 3000
    
    var name : String?
    var telephone : String?
    var detailAddress : String?
    var lat : Double = 0.0//latitude
    var lon : Double = 0.0//longitude
    
    func initloaddate(){
        areaNameLabel.text! = name!
        telephoneLabel.text! = telephone!
        detailAddressLabel.text! = detailAddress!
    }
    
    func mapItem()->MKMapItem{
        let addressDict = [CNPostalAddressStreetKey: name!]
        let placemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon), addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
    
    func centerMapOnLocation(location: CLLocation){
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        map.setRegion(coordinateRegion, animated: true)
    }
    
    func pinSetting(){
        let point = MKPointAnnotation()
        point.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        point.title = areaNameLabel.text
        point.subtitle = detailAddressLabel.text
        map.addAnnotation(point)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.delegate = self
        initloaddate()
        
        let initialLocation = CLLocation(latitude: lat, longitude: lon)
        centerMapOnLocation(location: initialLocation)
        // 핀설정
        pinSetting()
    }
    

    func mapView(_ mapView: MKMapView, annotationView view:MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl){
        
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        
        mapItem().openInMaps(launchOptions: launchOptions)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation:MKAnnotation)->MKAnnotationView?{
        
        let identifier = "marker"
        var view:MKMarkerAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView{
            dequeuedView.annotation = annotation
            view = dequeuedView
        }
        else{
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
}
