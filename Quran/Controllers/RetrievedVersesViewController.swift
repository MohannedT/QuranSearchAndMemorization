//
//  RetrievedVersesViewController.swift
//  Quran
//
//  Created by Eyad Shokry on 2/14/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit

class RetrievedVersesViewController: UIViewController {
    
    @IBOutlet weak var versesTableView: UITableView!
    var retrievedVerses = [[String]]()
    var userQuery = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        versesTableView.dataSource = self
        versesTableView.delegate = self
        
        let searchByQuranVC = storyboard?.instantiateViewController(withIdentifier: "SearchQuranByVoice") as! SearchQuranByVoiceViewController
        
        print("User query \(userQuery)")
        retrievedVerses = searchByQuranVC.SearchForWord(Word: userQuery)
        print("\n\n\n this is table view \n")
        print(retrievedVerses)
    }

}


extension RetrievedVersesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return retrievedVerses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ayaCell = versesTableView.dequeueReusableCell(withIdentifier: "VerseCell", for: indexPath) as! AyaTableViewCell
        ayaCell.configureCellWith(chapterNumber: retrievedVerses[indexPath.row][0], suraName: retrievedVerses[indexPath.row][4], ayaText: retrievedVerses[indexPath.row][3])
        
        return ayaCell
    }
    
}
