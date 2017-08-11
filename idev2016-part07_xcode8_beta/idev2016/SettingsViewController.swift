//
//  SettingsViewController.swift
//  idev2016
//
//  Created by Justin Domnitz on 7/31/16.
//  Copyright © 2016 Lowyoyo, LLC. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITabBarControllerDelegate {

    @IBOutlet weak var hashtag: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.delegate = self
    }

    // MARK - UITabBarControllerDelegate
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        for vc in tabBarController.viewControllers! {
            if let hvc = vc as? HomeViewController {
                let hashtagValue = hashtag?.text ?? ""
                hvc.hashtag = hashtagValue
                UserDefaults.standard.setValue(hashtagValue, forKey: "hashtag")
                UserDefaults.standard.synchronize()
            }
        }
    }
}
