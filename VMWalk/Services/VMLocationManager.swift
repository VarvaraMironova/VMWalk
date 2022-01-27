//
//  VMLocationManager.swift
//  VMWalk
//
//  Created by Varvara Myronova on 18.01.2022.
//

import Foundation
import CoreLocation

class VMLocationManager: NSObject, CLLocationManagerDelegate {
    var shared : CLLocationManager!
    
    @objc dynamic public var locationsList = [CLLocation]()
    @objc dynamic public var distance : Double = 0.0
    
    override init() {
        super.init()
        start()
    }
    
    //MARK: - Public
    public func stop() {
        shared.stopUpdatingLocation()
        shared = nil
        distance = 0
    }
    
    //MARK: - Private
    private func start() {
        shared = CLLocationManager()
        shared.delegate = self
        shared.requestWhenInUseAuthorization()
        shared.desiredAccuracy = kCLLocationAccuracyBest
        shared.allowsBackgroundLocationUpdates = true
        shared.distanceFilter = 10
        shared.activityType = .fitness
        shared.startUpdatingLocation()
    }
    
    //MARK: - CLLocationManagerDelegate
    func locationManager(_ manager              : CLLocationManager,
                         didFailWithError error : Error)
    {
        print(error)
    }
    
    func locationManager(_ manager                      : CLLocationManager,
                         didUpdateLocations locations   : [CLLocation])
    {
        
        for newLocation in locations {
            //check if the newLocation is not in the time and area bounds
            //if it's not, update the location list and the total distance
            let howRecent = newLocation.timestamp.timeIntervalSinceNow
            let isDistinctive = newLocation.horizontalAccuracy < 20
            
            guard isDistinctive && abs(howRecent) < 10 else { continue }
            
            if let lastLocation = locationsList.last {
                let delta = newLocation.distance(from: lastLocation)
                distance += delta
            }

            locationsList.append(newLocation)
        }
    }
    
}
