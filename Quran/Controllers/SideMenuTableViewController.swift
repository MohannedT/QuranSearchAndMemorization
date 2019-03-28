//
//  SideMenuTableViewController.swift
//  Quran
//
//  Created by Eyad Shokry on 3/28/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit
import SideMenu

class SideMenuTableViewController: UITableViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        guard SideMenuManager.default.menuBlurEffectStyle == nil else {
            return
        }
        
        let imageView = UIImageView(image: UIImage(named: "sideMenuBackground"))
        tableView.backgroundView = imageView
        
    }

}
