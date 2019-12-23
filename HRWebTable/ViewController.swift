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
    @IBOutlet weak var myActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        load()
    }

    func load() {
        myWebView.load(URLRequest(url: targetURL!))
    }
    
    

}

extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        myActivityIndicator.isHidden = false;
        myActivityIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        myActivityIndicator.isHidden = true;
    }
}
