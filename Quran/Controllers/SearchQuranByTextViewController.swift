//
//  SearchQuranByTextViewController.swift
//  Quran
//
//  Created by Eyad Shokry on 2/14/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit

class SearchQuranByTextViewController: UIViewController {
    @IBOutlet weak var userQueryTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!

    @IBAction func onClickSearchButton(_ sender: UIButton) {
        performSegue(withIdentifier: "ShowVersesSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let retrievedVersesVC = segue.destination as! RetrievedVersesViewController
        retrievedVersesVC.userQuery = self.userQueryTextField.text!
    }
}
