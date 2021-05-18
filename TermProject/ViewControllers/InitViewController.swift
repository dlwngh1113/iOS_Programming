//
//  InitViewController.swift
//  TermProject
//
//  Created by kpugame on 2021/05/18.
//

import UIKit

class InitViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var signatureImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        signatureImageView.image = UIImage(named: "signature.png")
        // Do any additional setup after loading the view.
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
