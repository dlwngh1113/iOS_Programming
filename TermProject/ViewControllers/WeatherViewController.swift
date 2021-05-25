//
//  WeatherTableViewController.swift
//  TermProject
//
//  Created by kpugame on 2021/05/23.
//

import UIKit

class WeatherViewController: UIViewController, XMLParserDelegate {
    @IBOutlet var imageView: UIImageView!
    
    var url: String?
    var sgguCd: String? //지역명
    
    var parser = XMLParser()
    
    var posts = NSMutableArray()
    
    var elements = NSMutableDictionary()
    var element = NSString()
    
    //var time: String? = "&base_time=1400" //예보시간 - 고정
    var date: String? = "&base_date=" //예보날짜
    var position: String? //지역의 xy
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI :String?,
                qualifiedName qName: String?, attributes attributeDict: [String: String]) {
        element = elementName as NSString
        if (elementName as NSString).isEqual(to: "row")
        {
            elements = NSMutableDictionary()
            elements = [:]
            SIGUN_NM = NSMutableString()
            SIGUN_NM = ""
            NM_SM_NM = NSMutableString()
            NM_SM_NM = ""
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
        else if element.isEqual(to: "NM_SM_NM")
        {
            NM_SM_NM.append(string)
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
            if !NM_SM_NM.isEqual(nil)
            {
                elements.setObject(NM_SM_NM, forKey: "NM_SM_NM" as NSCopying)
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
    
    func beginParsing()
    {
        posts = []
        initAreaPosition()
        url! += date! + position!
        parser = XMLParser(contentsOf: (URL(string: url!))!)!
        parser.delegate = self
        parser.parse()
    }
    
    func getDate()
    {
        let today = NSDate()
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyyMMdd"
        let date = dateFormatter.string(from: today as Date)
        self.date! += date
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDate()
        beginParsing()
    }
    
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
}
