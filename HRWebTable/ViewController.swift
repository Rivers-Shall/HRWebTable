//
//  ViewController.swift
//  HRWebTable
//
//  Created by 肖江 on 2019/12/23.
//  Copyright © 2019 rivers. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    var targetURL : URL?
    
    @IBOutlet weak var myWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        load()
    }

    func load() {
        myWebView.load(URLRequest(url: targetURL!))
    }
    
    

}
