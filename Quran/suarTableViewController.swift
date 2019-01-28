//
//  suarTableViewController.swift
//  Quran
//
//  Created by Ahmed khattab on 1/24/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit

class suarTableViewController: UITableViewController {
    
    @IBOutlet var suarTableView: UITableView!
    //var suarArray = [[String:Any]]()
    var surasNamesArray = ["fatehah", "baqara", "Al Omran"]
    var numberOfVersesArray = [8, 300, 100]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // suarArray = [["Name": "haFat" , "Verses" : 10], ["Name": "baqara" , "Verses" : 320]]
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
      //  return suarArray.count
        return surasNamesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "sura", for: indexPath)
        let suraName  = surasNamesArray[indexPath.row]
        cell.textLabel?.text = suraName
        cell.backgroundColor = UIColor.green;
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectVersesVC = storyboard?.instantiateViewController(withIdentifier: "selectVerses") as! selectVersesViewController
        selectVersesVC.suraName = surasNamesArray[indexPath.row]
        selectVersesVC.suraVersesNumber = numberOfVersesArray[indexPath.row]
        for var i in (1...numberOfVersesArray[indexPath.row]) {
            selectVersesVC.versesArray.append(i)
        }

        navigationController?.pushViewController(selectVersesVC, animated: true)
    }
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        if(segue.identifier == "selectVerseSegue") {
//
//            let vc = segue.destination as? selectVersesViewController
//            vc?.suraDictionary = sender as! [String : Any]
//        }
    
    }
