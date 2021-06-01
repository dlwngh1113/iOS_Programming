//
//  PlaceView.swift
//  TermProject
//
//  Created by kpugame on 2021/06/01.
//
import Foundation
import MapKit

class PlaceMarkerView: MKMarkerAnnotationView{
    override var annotation: MKAnnotation?{
        willSet{
            guard let place = newValue as? Place else {return}
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            markerTintColor = place.markerTintColor
        }
    }
}
