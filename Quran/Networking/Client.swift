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
    

    func getDataFromURL(longitude: Double, latitude: Double, elevation: Double, completionHandler: @escaping (_ result: DateTimeData?, _ error: NSError?) -> Void) {
        //let url = URL(string: urlString+userCity)
        let url = buildURLFromParameters(["longitude": String(longitude),
                                          "latitude": String(latitude),
                                          "elevation": String(elevation),
                                          "timeformat": "1"
                                          ])

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandler(nil, NSError(domain: "getDataFromURL", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError("An error happened with your request: \(error!.localizedDescription)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned status code other than 2XX!")
                return
            }
            
            guard let data = data else {
                sendError("No Data returned from your Request")
                return
            }
            
            do {
                let result = try JSONDecoder().decode(MyData.self, from: data)
                print(result)
                let results = result.results
                let dateTime = results.datetime
                let times = dateTime[0]
                print("done")
                completionHandler(times, nil)
                } catch let error as NSError {
                    sendError("An Error happend while decoding data: \(error.localizedDescription)")
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
        print(components.url!)
        return components.url!
    }
}

struct PrayerTimesConstants {
    static let APIScheme = "https"
    static let APIHost = "api.pray.zone"
    static let APIPath = "/v2/times/today.json"
}
