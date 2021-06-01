//
//  Place.swift
//  TermProject
//
//  Created by kpugame on 2021/06/01.
//

import Foundation
import MapKit

import Contacts
class Place: NSObject, MKAnnotation{
    let title:String?
    let locationName:String?
    let coordinate:CLLocationCoordinate2D
    var markerTintColor: UIColor{.red}
    init(title:String, locationName:String, coordinate: CLLocationCoordinate2D){
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String?{
        return locationName
    }
    //info
    func mapItem()->MKMapItem{
        let addressDict = [CNPostalAddressStreetKey: subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
}
