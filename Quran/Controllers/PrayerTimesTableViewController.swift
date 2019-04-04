//
//  PrayerTimesTableViewController.swift
//  Quran
//
//  Created by Eyad Shokry on 3/30/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit
import CoreLocation

class PrayerTimesTableViewController: UITableViewController, CLLocationManagerDelegate {

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
        
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        var currentLocation: CLLocation!
        
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways) {
            currentLocation = locationManager.location
            print(currentLocation.coordinate.latitude)
            print(currentLocation.coordinate.longitude)
            print(currentLocation.altitude)
            fetchPrayTimesFromApi(long: currentLocation.coordinate.longitude,
                                  lat: currentLocation.coordinate.latitude,
                                  elevation: currentLocation.altitude)
        }

        performUIUpdatesOnMain {
            self.prayerTimesTableView.reloadData()
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    }
    
    func fetchPrayTimesFromApi(long: Double, lat: Double, elevation: Double) {
        activityIndicator.startAnimating()
        Client.shared().getDataFromURL(longitude: long, latitude: lat, elevation: elevation, completionHandler: {(dateTimeData, error) in
            
            if let error = error {
                self.showAlertController(withTitle: "Error fetching Pray times", withMessage: error.localizedDescription)
            }
            
            else if let timeData = dateTimeData {
                self.performUIUpdatesOnMain {
                    self.fajrTimeLabel.text = timeData.times.Fajr
                    self.sunshineTimeLabel.text = timeData.times.Sunrise
                    self.dhuhrTimeLabel.text = timeData.times.Dhuhr
                    self.asrTimeLabel.text = timeData.times.Asr
                    self.maghribTimeLabel.text = timeData.times.Maghrib
                    self.ishaTimeLabel.text = timeData.times.Isha
                }
            }
        })
    }
}
