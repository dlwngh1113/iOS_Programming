//
//  LeisureDetailViewController.swift
//  TermProject
//
//  Created by kpugame on 2021/05/25.
//

import UIKit
import MapKit
import Contacts

class LeisureDetailViewController: UIViewController, MKMapViewDelegate{

    @IBOutlet weak var leisureNameLabel: UILabel!
    @IBOutlet weak var telephoneLabel: UILabel!
    @IBOutlet weak var detailAddressLabel: UILabel!
    @IBOutlet weak var map: MKMapView!
    
    let regionRadius: CLLocationDistance = 1000
    
    var posts = NSMutableArray()
    
    var name : String?
    var lat : Double = 0.0//latitude
    var lon : Double = 0.0//longitude
    
    func initloaddate(){
        for post in posts {
            leisureNameLabel.text = (post as AnyObject).value(forKey: "SI_DESC") as! NSString as String
            telephoneLabel.text = (post as AnyObject).value(forKey: "TELNO") as! NSString as String
            detailAddressLabel.text = (post as AnyObject).value(forKey: "SM_RE_ADDR") as! NSString as String
            let XPos = (post as AnyObject).value(forKey: "REFINE_WGS84_LAT") as! NSString as String
            let YPos = (post as AnyObject).value(forKey: "REFINE_WGS84_LOGT") as! NSString as String
            lat = (YPos as NSString).doubleValue
            lon = (XPos as NSString).doubleValue
        }
        
        name = leisureNameLabel.text!
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
        point.title = leisureNameLabel.text
        point.subtitle = detailAddressLabel.text
        map.addAnnotation(point)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.delegate = self
        initloaddate()
        
        let initialLocation = CLLocation(latitude: 37.5384514, longitude: 127.0709764)
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
