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
    var ayatText = [String]()
    var chapterNumbers = [String]()
    var partNumbers = [String]()
    var soraNames = [String]()
    var versesNumbers = [String]()
    var subTopics = [String]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        versesTableView.dataSource = self
        versesTableView.delegate = self
        
        getAyatFromMostSimilarTopic()
    }

    func getAyatFromTopic(){
        Client.shared().getDataFromTopicAyatAPI(topic: userQuery, completionHandler: {(data, error) in
            if error != nil {
                self.showAlertController(withTitle: "Error fetching Ayat", withMessage: "We didn't find any Information, Be sure to be connected with Internet or try again later.")
            }
            
            else if let fetchedData = data {
                for subTopic in fetchedData.SubTopics {
                    print(subTopic)
                }
                for aya in fetchedData.Ayat {
                    print(aya.AyaText)
                }
            }
        })
    }
    
    
    func getAyatFromMostSimilarTopic(){
        Client.shared().getDataFromMostSimilarTopicsAPI(query: userQuery, completionHandler: {(data, error) in
            if error != nil {
                self.showAlertController(withTitle: "Error fetching Ayat", withMessage: "We didn't find any Information, Be sure to be connected with Internet or try again later.")
            }
            
            else if let fetchedData = data {
                for topic in fetchedData {
                    if topic.Ranking == "1" {
                        print(topic.SubTopics)
                    }
                }
            }
        })
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
