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
    
    var category = NSMutableString()
    var categoryValue = NSMutableString()
    var fcstTime = NSMutableString()
    
    var date: String? = "&base_date=" //예보날짜
    var position: String? //지역의 xy
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI :String?,
                qualifiedName qName: String?, attributes attributeDict: [String: String]) {
        element = elementName as NSString
        if (elementName as NSString).isEqual(to: "item")
        {
            elements = NSMutableDictionary()
            elements = [:]
            
            category = NSMutableString()
            category = ""
            
            categoryValue = NSMutableString()
            categoryValue = ""
            
            fcstTime = NSMutableString()
            fcstTime = ""
        }
    }
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        if element.isEqual(to: "fcstTime")
        {
            if(string.contains("1500"))
            {
                fcstTime.append(string)
            }
            else
            {
                //fcstTime = nil
            }
        }
        else if element.isEqual(to: "category")
        {
            if(string.contains("POP"))
            {
                category.append(string)
            }
            else if(string.contains("SKY"))
            {
                category.append(string)
            }
            else if(string.contains("TMX"))
            {
                category.append(string)
            }
            else
            {
                return
            }
        }
        else if element.isEqual(to: "fcstValue")
        {
            categoryValue.append(string)
        }
    }
    func parser(_ parser:XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if (elementName as NSString).isEqual(to: "item")
        {
            if !fcstTime.isEqual(nil)
            {
                elements.setObject(fcstTime, forKey: "fcstTime" as NSCopying)
            }
            if !category.isEqual(nil)
            {
                elements.setObject(category, forKey: "category" as NSCopying)
            }
            if !categoryValue.isEqual(nil)
            {
                elements.setObject(categoryValue, forKey: "fcstValue" as NSCopying)
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
        print(posts)
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
