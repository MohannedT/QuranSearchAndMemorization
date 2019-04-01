//
//  Client.swift
//  Quran
//
//  Created by Eyad Shokry on 3/29/19.
//  Copyright © 2019 Eyad Shokry. All rights reserved.
//

import UIKit

class Client: NSObject {
    var session = URLSession.shared
    
    override init() {
        super.init()
    }
    
    class func shared() -> Client {
        struct Singleton {
            static var shared = Client()
        }
        return Singleton.shared
    }
    
    let urlString = "https://api.pray.zone/v2/times/today.json?city="
    
    func getDataFromURL(userCity: String, completionHandler: @escaping (_ result: DateTimeData?, _ error: NSError?) -> Void) {
        let url = URL(string: urlString+userCity)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                do {
                    let result = try JSONDecoder().decode(MyData.self, from: data!)
                    let results = result.results
                    let dateTime = results.datetime
                    let times = dateTime[0]
                    print(type(of: times.times))
                    completionHandler(times, nil)
                    
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
        }.resume()
        
    }
    
    private func buildURLFromParameters(_ parameters: [String: String]) -> URL {
        var components = URLComponents()
        components.scheme = PrayerTimesConstants.APIScheme
        components.host = PrayerTimesConstants.APIHost
        components.path = PrayerTimesConstants.APIPath
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: value)
            components.queryItems?.append(queryItem)
        }
        return components.url!
    }
}

struct PrayerTimesConstants {
    static let APIScheme = "https"
    static let APIHost = "api.pray.zone"
    static let APIPath = "/v2/times/today.json"
}
