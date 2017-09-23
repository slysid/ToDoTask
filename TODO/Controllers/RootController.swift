//
//  ViewController.swift
//  TODO
//
//  Created by Bharath on 2017-09-20.
//  Copyright © 2017 Bharath. All rights reserved.
//

import UIKit

class RootController: UIViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        let summaryController = SummaryController(nibName: "SummaryController", bundle: Bundle.main)
        self.present(summaryController, animated: true) {
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

