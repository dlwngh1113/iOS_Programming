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
        
        if let navController = self.customizableViewControllers![0] as? UINavigationController
        {
            if let tabBarController = navController.topViewController as? LeisureTableViewController
            {
                tabBarController.url = leisureURL
                tabBarController.sgguCd = sgguCd
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueToLeisureView"
        {
            if let navController = segue.destination as? UINavigationController{
                if let leisureTableView = navController.topViewController as? LeisureTableViewController
                {
                    leisureTableView.url = leisureURL
                    leisureTableView.sgguCd = sgguCd
                }
            }
        }
        
        if segue.identifier == "SegueToAreaView"
        {
//            if let navController = segue.destination as? UINavigationController{
//                if let areaTableView = navController.topViewController as? AreaTableViewController
//                {
//                    areaTableView.url = leisureURL
//                    areaTableView.sgguCd = sgguCd
//                }
//            }
        }
        
        if segue.identifier == "SegueToWeatherView"
        {
            if let navController = segue.destination as? UINavigationController{
//                if let weatherView = navController.topViewController as? AreaTableViewController
//                {
//                    weatherView.url = leisureURL
//                    weatherView.sgguCd = sgguCd
//                }
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
