//
//  WebViewController.swift
//  ChronologicalOrderGame-TD-Project-3
//
//  Created by Andrew Graves on 5/31/19.
//  Copyright © 2019 Andrew Graves. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    var url: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURL = URL(string: url)
        let myRequest = URLRequest(url: myURL!)
        self.webView.load(myRequest)

        // Do any additional setup after loading the view.
    }
    
    // When the button is pressed
    @IBAction func dismissButtonPressed(_ sender: Any) {
        
        // dismiss the webview popup
        dismiss(animated: true, completion: nil)
    }
}
