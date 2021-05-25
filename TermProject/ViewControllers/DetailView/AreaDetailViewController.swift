//
//  AreaDetailViewController.swift
//  TermProject
//
//  Created by kpugame on 2021/05/25.
//

import UIKit
import MapKit

class AreaDetailViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var areaNameLabel: UILabel!
    @IBOutlet weak var telephoneLabel: UILabel!
    @IBOutlet weak var detailAddressLabel: UILabel!
    @IBOutlet weak var map: MKMapView!
    
    let regionRadius: CLLocationDistance = 5000
    
    var posts = NSMutableArray()
    
    var lat : Double = 0.0//latitude
    var lon : Double = 0.0//longitude
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


}
