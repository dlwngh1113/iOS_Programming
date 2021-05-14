//
//  InitViewController.swift
//  TermProject
//
//  Created by kpugame on 2021/05/15.
//

import Foundation
import UIKit

class InitViewController:UIViewController
{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToPickerView"
        {
            if let pickerController = segue.destination as? UINavigationController
            {
                if let pickerViewContorller = pickerController.topViewController as? PickerViewController
                {
                    
                }
            }
        }
    }
}
