//
//  webViewController.swift
//  WikipediaSearch
//
//  Created by venkat on 26/08/18.
//  Copyright © 2018 freelancer. All rights reserved.
//

import UIKit

class webViewController: UIViewController {
    @IBOutlet weak var webview: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let feedtitle = UserDefaults.standard.value(forKey: "feedtitle") as! String
        let urlString = feedtitle.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)

        let url = URL (string:"https://en.wikipedia.org/wiki/\(urlString!)")
        let requestObj = URLRequest(url: url!)
        DispatchQueue.main.async(execute: {() -> Void in

            self.webview.loadRequest(requestObj)

        })
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
