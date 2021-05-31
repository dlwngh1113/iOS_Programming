//
//  WeatherTableViewController.swift
//  TermProject
//
//  Created by kpugame on 2021/05/23.
//

import UIKit
import SwiftUI

class WeatherViewController: UIViewController, XMLParserDelegate, UIScrollViewDelegate {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var containerViews:[UIView] = []
    
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
    var labelDate: String{
        let today = NSDate()
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let curDate = dateFormatter.string(from: today as Date)
        return curDate
    }
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
            fcstTime.append(string)
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
            else if(string.contains("T3H"))
            {
                category.append(string)
            }
            else if(string.contains("PTY"))
            {
                category.append(string)
            }
            else
            {
                category.append("")
            }
        }
        else if element.isEqual(to: "fcstValue")
        {
            if(fcstTime.isEqual(to: "") || category.isEqual(to: ""))
            {
                categoryValue.append("")
                return
            }
            categoryValue.append(string)
        }
    }
    func parser(_ parser:XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if (elementName as NSString).isEqual(to: "item")
        {
            if !fcstTime.isEqual(to: "")
            {
                elements.setObject(fcstTime, forKey: "fcstTime" as NSCopying)
            }
            else
            {
                return
            }
            if !category.isEqual(to: "")
            {
                elements.setObject(category, forKey: "category" as NSCopying)
            }
            else
            {
                return
            }
            if !categoryValue.isEqual(to: "")
            {
                elements.setObject(categoryValue, forKey: "fcstValue" as NSCopying)
            }
            else
            {
                return
            }
            
            posts.add(elements)
        }
    }
    
    func beginParsing()
    {
        posts = []
        initAreaPosition()
        parser = XMLParser(contentsOf: (URL(string: url! + date! + getDate() + position!))!)!
        parser.delegate = self
        parser.parse()
    }
    
    func setGlobalData()
    {
        for i in 0..<posts.count
        {
            let dic = posts[i] as! NSMutableDictionary
            if (dic["category"] as! NSMutableString).isEqual(to: "POP")
            {
                globalMeasurements.append(TimeInfo(time: (dic["fcstTime"] as! NSString) as String,
                                                         pop: (dic["fcstValue"] as! NSString) as String, t3h: nil))
                measurementsCount += 1
            }
            else if (dic["category"] as! NSMutableString).isEqual(to: "T3H")
            {
                globalMeasurements[measurementsCount - 1].t3h = (dic["fcstValue"] as! NSString) as String
                globalMeasurements[measurementsCount - 1].time?.removeLast(2)
            }
        }
    }
    
    func getDate() -> String
    {
        let today = NSDate()
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyyMMdd"
        let date = dateFormatter.string(from: today as Date)
        return date
    }
    
    func setImage()
    {
        dateLabel.text = labelDate
        for i in 0..<posts.count
        {
            let dic = posts[i] as! NSMutableDictionary
            if (dic["category"] as! NSMutableString).isEqual(to: "PTY")
            {
                let fcstValue = ((dic["fcstValue"] as! NSString) as String)
                switch fcstValue {
                case "1", "2", "4", "5", "6":
                    imageView.image = UIImage(named: "rain")
                    break
                case "3", "7":
                    imageView.image = UIImage(named: "snow")
                default:
                    break
                }
            }
            else if (dic["category"] as! NSMutableString).isEqual(to: "SKY")
            {
                let fcstValue = ((dic["fcstValue"] as! NSString) as String)
                switch fcstValue {
                case "1":
                    imageView.image = UIImage(named: "sunny")
                    break
                case "3":
                    imageView.image = UIImage(named: "cloud")
                    break
                case "4":
                    imageView.image = UIImage(named: "manyCloud")
                    break
                default:
                    break
                }
            }
        }
    }
    
    func purgePage(_ page:Int)
    {
        if page < 0 || page >= containerViews.count
        {
            return
        }
        
        let viewcontrollers = self.children
        for viewcontroller in viewcontrollers
        {
            viewcontroller.willMove(toParent: nil)
            viewcontroller.view.removeFromSuperview()
            viewcontroller.removeFromParent()
        }
    }
    
    func loadPage(_ page: Int)
    {
        if(page < 0 || page >= containerViews.count)
        {
            return
        }
        
        var frame = scrollView.bounds
        frame.origin.x = frame.size.width * CGFloat(page)
        frame.origin.y = 0.0
        frame.size.height -= 50
        
        containerViews[page].frame = frame
        
        var controller: UIViewController
        if(page == 0)
        {
            controller = UIHostingController(rootView: PrecipitationChart(measurements: globalMeasurements))
        }
        else
        {
            controller = UIHostingController(rootView: TemperatureChart(measurements: globalMeasurements))
        }
        
        addChild(controller)
        containerViews[page].addSubview(controller.view)
        
        controller.view.frame = containerViews[page].bounds
        controller.didMove(toParent: self)
        
        scrollView.addSubview(containerViews[page])
    }
    
    func loadSwiftUIViews()
    {
        let pageWidth = scrollView.frame.width
        let page = Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / pageWidth / 2.0))
        
        pageControl.currentPage = page
        let lastPage = page + 1
        
        for index in 0..<lastPage + 1{
            purgePage(index)
        }
        
        loadPage(page)
    }
    
    func initScrollView()
    {
        pageControl.currentPage = 0
        pageControl.numberOfPages = 2
        
        scrollView.delegate = self
        
        let pagesScrollViewSize = scrollView.frame.size
        scrollView.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(pageControl.numberOfPages), height: pagesScrollViewSize.height - 50)
        
        let precipitationView = UIView()
        precipitationView.frame = scrollView.bounds
        precipitationView.frame.origin.y = 0.0
        precipitationView.frame.size.height -= 50
        
        let temperatureView = UIView()
        temperatureView.frame = scrollView.bounds
        temperatureView.frame.origin.y = 0.0
        temperatureView.frame.size.height -= 50
        
        containerViews = [
        precipitationView, temperatureView]
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        loadSwiftUIViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beginParsing()
        setImage()
        initScrollView()
        loadSwiftUIViews()
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
