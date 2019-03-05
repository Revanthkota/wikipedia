//
//  ViewController.swift
//  WikipediaSearch
//
//  Created by venkat on 24/08/18.
//  Copyright © 2018 freelancer. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UISearchResultsUpdating,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate{
  
    
    let searchController = UISearchController(searchResultsController: nil)
    var feeds = NSMutableArray()
    var statuscheck = Bool()

    @IBOutlet weak var tblview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblview.tableFooterView = UIView()
        statuscheck = false
       // setup(flickrURL :"bangalore")

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search here"
       // navigationItem.searchController = searchController
       tblview.tableHeaderView = searchController.searchBar

        definesPresentationContext = true
        // Do any additional setup after loading the view, typically from a nib.
    }
override func viewWillAppear(_ animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //setup for api calling
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return  self.feeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell

        let feed = self.feeds[indexPath.row] as! Dataclass
        
        cell.titlename?.text = feed.title
        cell.descriptlbl?.text = feed.descript

      if feed.media != nil
      {
        
        let url = URL(string: feed.media!)
        
        print("image url: \(String(describing: url))")
        let task = URLSession.shared.dataTask(with: url!, completionHandler: {(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void in
            
            if data != nil {
                
                let image = UIImage(data: data!)
                
                if image != nil {
                    
                    DispatchQueue.main.async(execute: {() -> Void in
                            cell.imgview.image = image
                            cell.imgview.layer.masksToBounds = true
                 
                    })
                    
                }
                
            }
      }) as URLSessionDataTask
        task.resume()
        }
      
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let centerviewcontroller =  self.storyboard?.instantiateViewController(withIdentifier: "webViewController") as! webViewController
        
        let feed = self.feeds[indexPath.row] as! Dataclass
        print(feed.title!)
        
        //saving in NSUserDefaults
        UserDefaults.standard.set(feed.title!, forKey: "feedtitle")
        self.navigationController?.pushViewController(centerviewcontroller, animated: true)

    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 70
//    }
    

func setup(flickrURL :NSString) {
    statuscheck = true
        self.feeds = NSMutableArray()
  //let trimmedString = flickrURL.trimmingCharacters(in: .whitespaces)
    let urlString = flickrURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)

    let url = NSURL(string: urlString!)
    if let flickrURL = NSURL(string: "https://en.wikipedia.org//w/api.php?action=query&format=json&prop=pageimages%7Cpageterms&generator=prefixsearch&redirects=1&formatversion=2&piprop=thumbnail&pithumbsize=50&pilimit=10&wbptterms=description&gpssearch=\(url!)&gpslimit=10") {
            
            let request = URLRequest(url:flickrURL as URL)
            let task = URLSession.shared.dataTask(with: request) {
                data, response, error in
                
                do {
                    let list = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary
                    let query = list?.value(forKey: "query") as? NSDictionary
                    let items = query?.value(forKey: "pages") as? NSArray
                    if items != nil
                    {
                        for item in items!
                    {
                        let dictionaryItem = item as! NSDictionary
                        
                        let feed = Dataclass()
                        
                        feed.title = dictionaryItem.value(forKey: "title") as? String
                         let sourceimage = dictionaryItem.value(forKey: "thumbnail") as? NSDictionary
                        feed.media = sourceimage?.value(forKeyPath: "source") as? String
                        let termsdict = dictionaryItem.value(forKey: "terms") as? NSDictionary
                        let descriptarr = termsdict?.value(forKey: "description") as? NSArray
                        feed.descript = descriptarr?.object(at: 0) as? String
                        self.feeds.add(feed)
                        self.statuscheck = false
                    }
                        DispatchQueue.main.async(execute: {() -> Void in
                            self.tblview.reloadData()
                        })
                    }
                    print("added users:\(self.feeds)")
                    
                }catch{
                    print("error\(error)")
                }
            }
            task.resume()
            
        }
    }
    //search resultes updatation..
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
 
            let flickrURL = searchText as NSString
            
            if (statuscheck == false)
            {
            setup(flickrURL: flickrURL )
            }
            
            
          //  searchBar.resignFirstResponder()
            print("searching text: \(searchText)")
           
            
        } else {
        }
        
        DispatchQueue.main.async(execute: {() -> Void in
            self.tblview.reloadData()
        })
        
    }


}

