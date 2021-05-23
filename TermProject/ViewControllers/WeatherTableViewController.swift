//
//  WeatherTableViewController.swift
//  TermProject
//
//  Created by kpugame on 2021/05/23.
//

import UIKit

class WeatherTableViewController: UITableViewController, XMLParserDelegate {

    @IBOutlet var weatherTableView: UITableView!
    
    var url: String?
    var sgguCd: String? //지역명
    
    var parser = XMLParser()
    
    var posts = NSMutableArray()
    
    var elements = NSMutableDictionary()
    var element = NSString()
    
    //var time: String? = "&base_time=1400" //예보시간 - 고정
    var date: String? = "&base_date=20210523" //예보날짜
    var position: String? //지역의 xy
    
    func initAreaPosition()
    {
        switch sgguCd {
        case "수원시":
            self.position = "&nx=60&ny=121"
            break
        case "용인시":
            self.position = "&nx=62&ny=120"
            break
        case "성남시":
            self.position = "&nx=63&ny=124"
            break
        case "부천시":
            self.position = "&nx=56&ny=125"
            break
        case "화성시":
            self.position = "&nx=57&ny=119"
            break
        case "안산시":
            self.position = "&nx=58&ny=121"
            break
        case "안양시":
            self.position = "&nx=59&ny=123"
            break
        case "평택시":
            self.position = "&nx=62&ny=114"
            break
        case "시흥시":
            self.position = "&nx=56&ny=122"
            break
        case "김포시":
            self.position = "&nx=55&ny=128"
            break
        case "광주시":
            self.position = "&nx=65&ny=123"
            break
        case "광명시":
            self.position = "&nx=58&ny=125"
            break
        case "군포시":
            self.position = "&nx=59&ny=122"
            break
        case "하남시":
            self.position = "&nx=64&ny=126"
            break
        case "오산시":
            self.position = "&nx=62&ny=118"
            break
        case "이천시":
            self.position = "&nx=68&ny=121"
            break
        case "안성시":
            self.position = "&nx=65&ny=115"
            break
        case "의왕시":
            self.position = "&nx=60&ny=122"
            break
        case "양평군":
            self.position = "&nx=69&ny=125"
            break
        case "여주시":
            self.position = "&nx=71&ny=121"
            break
        case "과천시":
            self.position = "&nx=60&ny=124"
            break
        case "고양시":
            self.position = "&nx=57&ny=128"
            break
        case "남양주시":
            self.position = "&nx=64&ny=128"
            break
        case "파주시":
            self.position = "&nx=56&ny=131"
            break
        case "의정부시":
            self.position = "&nx=61&ny=130"
            break
        case "양주시":
            self.position = "&nx61 &ny=131"
            break
        case "구리시":
            self.position = "&nx=62&ny=127"
            break
        case "포천시":
            self.position = "&nx=64&ny=134"
            break
        case "동두천시":
            self.position = "&nx=61&ny=134"
            break
        case "가평군":
            self.position = "&nx=69&ny=133"
            break
        case "연천군":
            self.position = "&nx=61&ny=138"
            break
        default:
            break
        }
    }
    
    func beginParsing()
    {
        posts = []
        initAreaPosition()
        url! += date! + position!
        parser = XMLParser(contentsOf: (URL(string: url!))!)!
        parser.delegate = self
        parser.parse()
        weatherTableView!.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beginParsing()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return posts.count
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
