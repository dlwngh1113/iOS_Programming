//
//  AreaDetailViewController.swift
//  TermProject
//
//  Created by kpugame on 2021/05/25.
//

import UIKit
import MapKit
import Contacts
import CoreLocation

class AreaDetailViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var areaNameLabel: UILabel!
    @IBOutlet weak var telephoneLabel: UILabel!
    @IBOutlet weak var detailAddressLabel: UILabel!
    @IBOutlet weak var map: MKMapView!
    var audioController: AudioController!

    let regionRadius: CLLocationDistance = 1000
    
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
    
    @IBAction func searchInNaver(_ sender: Any) {
        audioController.playerEffect(name: SoundButton)
        let temp = name?.components(separatedBy: [" ", "\n"]).joined().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let url = URL(string: "https://search.naver.com/search.naver?query=" + temp!),
              UIApplication.shared.canOpenURL(url) else {return}
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    @IBAction func searchInGoogle(_ sender: Any) {
        audioController.playerEffect(name: SoundButton)
        let temp = name?.components(separatedBy: [" ", "\n"]).joined().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let url = URL(string: "https://www.google.com/search?q=" + temp!),
              UIApplication.shared.canOpenURL(url) else {return}
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
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
        
        audioController = AudioController()
        audioController.preloadAudioEffects(audioFileNames: AudioEffectFiles)
        audioController.playerEffect(name: SoundPaging)
        
        map.delegate = self
        initloaddate()
        
        let initialLocation = CLLocation(latitude: lat, longitude: lon)
        centerMapOnLocation(location: initialLocation)
        // 핀설정
        //pinSetting()
        
        let place = Place(title: name!,
                              locationName: detailAddress!,
                              coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon))
        
        map.register(PlaceMarkerView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        map.addAnnotation(place)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 5.0
            return renderer
        }

    func mapView(_ mapView: MKMapView, viewFor annotation:MKAnnotation)->MKAnnotationView?{
        guard let annotation = annotation as? Place else {return nil}
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
    // MARK: - 길찾기
    func mapView(_ mapView: MKMapView, annotationView view:MKAnnotationView,
             calloutAccessoryControlTapped control: UIControl){
        let location = view.annotation as! Place
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
    
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
}

