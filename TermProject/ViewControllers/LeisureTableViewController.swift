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
    var parser = XMLParser()
    
    var posts = NSMutableArray()
    
    var elements = NSMutableDictionary()
    var element = NSString()
    
    var yadmNm = NSMutableString()
    var addr = NSMutableString()
    
    var XPos = NSMutableString()
    var YPos = NSMutableString()
    
    var hospitalname = ""
    var hospitalname_utf8 = ""
    
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
        if (elementName as NSString).isEqual(to: "item")
        {
            elements = NSMutableDictionary()
            elements = [:]
            yadmNm = NSMutableString()
            yadmNm = ""
            addr = NSMutableString()
            addr = ""
            //
            XPos = NSMutableString()
            XPos = ""
            YPos = NSMutableString()
            YPos = ""
        }
    }
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        if element.isEqual(to: "yadmNm")
        {
            yadmNm.append(string)
        }
        else if element.isEqual(to: "addr")
        {
            addr.append(string)
        }
        else if element.isEqual(to: "XPos")
        {
            XPos.append(string)
        }
        else if element.isEqual(to: "YPos")
        {
            YPos.append(string)
        }
    }
    func parser(_ parser:XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        if (elementName as NSString).isEqual(to: "item")
        {
            if !yadmNm.isEqual(nil)
            {
                elements.setObject(yadmNm, forKey: "yadmNm" as NSCopying)
            }
            if !addr.isEqual(nil)
            {
                elements.setObject(addr, forKey: "addr" as NSCopying)
            }
            if !XPos.isEqual(nil)
            {
                elements.setObject(XPos, forKey: "XPos" as NSCopying)
            }
            if !YPos.isEqual(nil)
            {
                elements.setObject(YPos, forKey: "YPos" as NSCopying)
            }
            
            posts.add(elements)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
}
