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
    var surasNamesArray = [String]()
    var numberOfVersesArray = [Int]()
    
    func getSurasNamesFromJSON(fileName: String) {
        let pathForJsonFile = Bundle.main.path(forResource: fileName, ofType: "json")
        let rawData = try? Data(contentsOf: URL(fileURLWithPath: pathForJsonFile!))
        let parsedJSONData = try! JSONSerialization.jsonObject(with: rawData!, options: .allowFragments) as! [[String:String]]
        for sura in parsedJSONData {
            self.surasNamesArray.append(sura["SuraName"]!)
        }
    }
    
    
    func getVersesNumbersFromJSON(fileName: String) {
        let pathForJsonFile = Bundle.main.path(forResource: fileName, ofType: "json")
        let rawData = try? Data(contentsOf: URL(fileURLWithPath: pathForJsonFile!))
        let parsedJSONData = try! JSONSerialization.jsonObject(with: rawData!, options: .allowFragments) as! [[String: Int]]
        for versesNumber in parsedJSONData {
            self.numberOfVersesArray.append(versesNumber["NumberofVerses"]!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getSurasNamesFromJSON(fileName: "suraNames")
        getVersesNumbersFromJSON(fileName: "numberOfVerses")
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        for i in (1...numberOfVersesArray[indexPath.row]) {
            selectVersesVC.versesArray.append(i)
        }

        navigationController?.pushViewController(selectVersesVC, animated: true)
    }
    	    
}


extension 
