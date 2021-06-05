//
//  LeisureTableViewController.swift
//  TermProject
//
//  Created by kpugame on 2021/05/18.
//

import UIKit

class LeisureTableViewController: UITableViewController, XMLParserDelegate {

    @IBOutlet var leisureTableView: UITableView!
    
    @IBOutlet weak var searchFooter: SearchFooter!
    let searchController = UISearchController(searchResultsController: nil)
    
    var filteredElements = NSMutableArray() // 필터링된 데이터들
    
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
        
        //검색 컨트롤러
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Leisure"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        searchController.searchBar.delegate = self
        
        //setup
        tableView.tableFooterView = searchFooter
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if isFiltering(){
            searchFooter.setIsFilteringToShow(filteredItemCount: filteredElements.count, of: posts.count)
            return filteredElements.count
        }
        
        searchFooter.setNotFiltering()
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeisureCell", for: indexPath)

        if isFiltering(){
            cell.textLabel?.text = (filteredElements.object(at: indexPath.row) as AnyObject).value(forKey:"SI_DESC") as! NSString as String
            
            cell.detailTextLabel?.text = (filteredElements.object(at: indexPath.row) as AnyObject).value(forKey:"SIGUN_NM") as! NSString as String
        }
        else {
        cell.textLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey:"SI_DESC") as! NSString as String
        
        cell.detailTextLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey:"SIGUN_NM") as! NSString as String
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell {
            let indexPath = tableView.indexPath(for: cell)
            if segue.identifier == "segueToLeisureDetail"{
                if let mapViewController = segue.destination as? LeisureDetailViewController{
                    
                    if isFiltering(){
                        let XPos = (filteredElements.object(at: (indexPath?.row)!) as AnyObject).value(forKey: "REFINE_WGS84_LOGT") as! NSString as String
                        let YPos = (filteredElements.object(at: (indexPath?.row)!) as AnyObject).value(forKey: "REFINE_WGS84_LAT") as! NSString as String
                        mapViewController.lat = (YPos as NSString).doubleValue
                        mapViewController.lon = (XPos as NSString).doubleValue
                        mapViewController.name = (filteredElements.object(at: (indexPath?.row)!) as AnyObject).value(forKey: "SI_DESC") as! NSString as String
                        mapViewController.telephone = (filteredElements.object(at: (indexPath?.row)!) as AnyObject).value(forKey: "TELNO") as! NSString as String
                        mapViewController.detailAddress = (filteredElements.object(at: (indexPath?.row)!) as AnyObject).value(forKey: "SM_RE_ADDR") as! NSString as String
                    }
                    else{
                        let XPos = (posts.object(at: (indexPath?.row)!) as AnyObject).value(forKey: "REFINE_WGS84_LOGT") as! NSString as String
                        let YPos = (posts.object(at: (indexPath?.row)!) as AnyObject).value(forKey: "REFINE_WGS84_LAT") as! NSString as String
                        mapViewController.lat = (YPos as NSString).doubleValue
                        mapViewController.lon = (XPos as NSString).doubleValue
                        mapViewController.name = (posts.object(at: (indexPath?.row)!) as AnyObject).value(forKey: "SI_DESC") as! NSString as String
                        mapViewController.telephone = (posts.object(at: (indexPath?.row)!) as AnyObject).value(forKey: "TELNO") as! NSString as String
                        mapViewController.detailAddress = (posts.object(at: (indexPath?.row)!) as AnyObject).value(forKey: "SM_RE_ADDR") as! NSString as String
                    }
                }
            }
        }
    }
    // MARK: - Search
    func searchBarisEmpty() -> Bool{
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All"){
        let filter = NSMutableArray()
        
        for i in 0..<posts.count{
            let name: String = (posts.object(at: i) as AnyObject).value(forKey: "SI_DESC") as! NSString as String
            
            if name.contains(searchText){
                filter.add(posts.object(at:i))
            }
        }
        
        filteredElements = filter
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool{
        let searchBarScopeIsFiletering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!searchBarisEmpty() || searchBarScopeIsFiletering)
    }
    
}

extension LeisureTableViewController: UISearchResultsUpdating{
    //MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        //TODO
        filterContentForSearchText(searchController.searchBar.text!)
        //let searchBar = searchController.searchBar
        //let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        //filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
}

extension LeisureTableViewController: UISearchBarDelegate{
    //MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int){
        filterContentForSearchText(searchBar.text!)
    }
}
