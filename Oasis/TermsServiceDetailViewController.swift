//
//  TermsServiceDetailViewController.swift
//  Oasis
//
//  Created by mac on 2017. 2. 2..
//  Copyright © 2017년 Needidsoft. All rights reserved.
//

import UIKit

class TermsServiceDetailViewController: UIViewController {
    @IBOutlet weak var webview: UIWebView!

    @IBAction func close(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    let url = "http://14.63.226.241:1205/agree"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        webview.loadRequest(URLRequest(url: URL(string: url)!))
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
