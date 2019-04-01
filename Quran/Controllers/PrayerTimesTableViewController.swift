//
//  PrayerTimesTableViewController.swift
//  Quran
//
//  Created by Eyad Shokry on 3/30/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit

class PrayerTimesTableViewController: UITableViewController {

    @IBOutlet var prayerTimesTableView: UITableView!
    @IBOutlet weak var fajrTimeLabel: UILabel!
    @IBOutlet weak var sunshineTimeLabel: UILabel!
    @IBOutlet weak var dhuhrTimeLabel: UILabel!
    @IBOutlet weak var asrTimeLabel: UILabel!
    @IBOutlet weak var maghribTimeLabel: UILabel!
    @IBOutlet weak var ishaTimeLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPrayTimesFromApi()
        prayerTimesTableView.reloadData()
    }
    
    func fetchPrayTimesFromApi() {
        activityIndicator.startAnimating()
        Client.shared().getDataFromURL(userCity: "Cairo", completionHandler: {(dateTimeData, error) in
            self.performUIUpdatesOnMain {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                
            }
            if let timeData = dateTimeData {
                self.performUIUpdatesOnMain {
                    self.fajrTimeLabel.text = timeData.times.Fajr
                    self.sunshineTimeLabel.text = timeData.times.Sunrise
                    self.dhuhrTimeLabel.text = timeData.times.Dhuhr
                    self.asrTimeLabel.text = timeData.times.Asr
                    self.maghribTimeLabel.text = timeData.times.Maghrib
                    self.ishaTimeLabel.text = timeData.times.Isha
                    
                    self.prayerTimesTableView.reloadData()
                }
            }
            else if let error = error {
                print(error.localizedDescription)
                return
            }            
        })
    }

}
