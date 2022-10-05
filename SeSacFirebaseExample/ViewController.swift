//
//  ViewController.swift
//  SeSacFirebaseExample
//
//  Created by 신동희 on 2022/10/05.
//

import UIKit
import FirebaseAnalytics

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        Analytics.logEvent("share_image", parameters: [
            "name": "고래밥",
            "full_text": "안녕",
        ])
        
        Analytics.setDefaultEventParameters([
            "level_name": "Caverns01",
            "level_difficulty": 4
        ])
        
        
        let button = UIButton(type: .roundedRect)
        button.frame = CGRect(x: 20, y: 50, width: 100, height: 30)
        button.setTitle("Test Crash", for: [])
        button.addTarget(self, action: #selector(self.crashButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(button)
    }

    
    @IBAction func crashButtonTapped(_ sender: AnyObject) {
        let numbers = [0]
        let _ = numbers[1]
    }
    
}

