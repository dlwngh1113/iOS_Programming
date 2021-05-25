//
//  LeisureTableViewController.swift
//  TermProject
//
//  Created by kpugame on 2021/05/18.
//

import UIKit

class LeisureTableViewController: UITableViewController, XMLParserDelegate {

    @IBOutlet var leisureTableView: UITableView!
    
    var url: String?
    var sgguCd: String? //지역명
    
    var parser = XMLParser()
    
    var posts = NSMutableArray()
    
    var elements = NSMutableDictionary()
    var element = NSString()
    
    var SIGUN_NM = NSMutableString() //시군명
    var SI_DESC = NSMutableString() // 시설명
    var SM_RE_ADDR = NSMutableString() //소재주소
    var TELNO = NSMutableString() //전화번호
    
    var XPos = NSMutableString() //위도
    var YPos = NSMutableString() //경도
    
    func beginParsing()
    {
        posts = []
        parser = XMLParser(contentsOf: (URL(string: url!))!)!
        parser.delegate = self
        parser.parse()
        leisureTableView!.reloadData()
    }
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI :String?,
                qualifiedName qName: String?, attributes attributeDict: [String: String]) {
        element = elementName as NSString
        if (elementName as NSString).isEqual(to: "row")
        {
            elements = NSMutableDictionary()
            elements = [:]
            SIGUN_NM = NSMutableString()
            SIGUN_NM = ""
            SI_DESC = NSMutableString()
            SI_DESC = ""
            SM_RE_ADDR = NSMutableString()
            SM_RE_ADDR = ""
            TELNO = NSMutableString()
            TELNO = ""
            //
            XPos = NSMutableString()
            XPos = ""
            YPos = NSMutableString()
            YPos = ""
        }
    }
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        if element.isEqual(to: "SIGUN_NM")
        {
            SIGUN_NM.append(string)
        }
        else if element.isEqual(to: "SI_DESC")
        {
            SI_DESC.append(string)
        }
        else if element.isEqual(to: "SM_RE_ADDR")
        {
            SM_RE_ADDR.append(string)
        }
        else if element.isEqual(to: "TELNO")
        {
            TELNO.append(string)
        }
        
        else if element.isEqual(to: "REFINE_WGS84_LAT")
        {
            XPos.append(string)
        }
        else if element.isEqual(to: "REFINE_WGS84_LOGT")
        {
            YPos.append(string)
        }
    }
    func parser(_ parser:XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if (elementName as NSString).isEqual(to: "row")
        {
            if !SIGUN_NM.isEqual(nil)
            {
                if(!SIGUN_NM.contains(sgguCd!)){
                    return
                }
                elements.setObject(SIGUN_NM, forKey: "SIGUN_NM" as NSCopying)
            }
            if !SI_DESC.isEqual(nil)
            {
                elements.setObject(SI_DESC, forKey: "SI_DESC" as NSCopying)
            }
            if !SM_RE_ADDR.isEqual(nil)
            {
                elements.setObject(SM_RE_ADDR, forKey: "SM_RE_ADDR" as NSCopying)
            }
            if !TELNO.isEqual(nil)
            {
                elements.setObject(TELNO, forKey: "TELNO" as NSCopying)
            }
            
            if !XPos.isEqual(nil)
            {
                elements.setObject(XPos, forKey: "REFINE_WGS84_LAT" as NSCopying)
            }
            if !YPos.isEqual(nil)
            {
                elements.setObject(YPos, forKey: "REFINE_WGS84_LOGT" as NSCopying)
            }
            
            posts.add(elements)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beginParsing()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeisureCell", for: indexPath)

        cell.textLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey:"SI_DESC") as! NSString as String
        
        cell.detailTextLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey:"SIGUN_NM") as! NSString as String

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToLeisureDetail"{
            if let mapViewController = segue.destination as? LeisureDetailViewController{
                mapViewController.posts = posts
            }
        }
        
    }
}
