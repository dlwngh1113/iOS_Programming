//
//  GlawTapBarController.swift
//  TermProject
//
//  Created by kpugame on 2021/05/21.
//

import UIKit

class GlawTapBarController: UITabBarController {

    var leisureURL:String?
    var areaURL:String?
    var weatherUIL: String?
    var sgguCd: String?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    func loadData()
    {
        if let navController = self.customizableViewControllers![0] as? UINavigationController
        {
            if let leisureViewController = navController.topViewController as? LeisureTableViewController
            {

                leisureViewController.url = leisureURL
                leisureViewController.sgguCd = sgguCd
                
            }
        }
        
        if let navController = self.customizableViewControllers![1] as? UINavigationController
        {
            if let areaViewController = navController.topViewController as? AreaTableViewController
            {
                areaViewController.url = areaURL
                areaViewController.sgguCd = sgguCd
            }
        }
        
        if let navController = self.customizableViewControllers![2] as? UINavigationController
        {
            if let weatherViewController = navController.topViewController as? WeatherViewController
            {
                globalMeasurements = []
                weatherViewController.url = weatherUIL
                weatherViewController.sgguCd = sgguCd
                weatherViewController.beginParsing()
                weatherViewController.setGlobalData()
            }
        }
    }
}
