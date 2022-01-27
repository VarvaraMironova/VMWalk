//
//  VMWalkViewController.swift
//  VMWalk
//
//  Created by Varvara Myronova on 17.01.2022.
//

import UIKit
import MapKit

class VMWalkViewController: UIViewController, MKMapViewDelegate {
    
    var walk : VMWalk?
    
    var stopwatch : VMStopwatch! {
        willSet(aNewValue) {
            if let aNewValue = aNewValue {
                let stopWatchToken = aNewValue.observe(\.counter) { stopwatch, change in
                    if let rootView = self.rootView {
                        rootView.updateStopWatch(stopwatch.counter)
                    }
                }
                
                KVOTokens.append(stopWatchToken)
            }
        }
    }
    
    var locationManager : VMLocationManager! {
        willSet(aNewValue) {
            if let aNewValue = aNewValue {
                let distanceToken = aNewValue.observe(\.distance) { locationManager, change in
                    if let rootView = self.rootView {
                        rootView.updateDistance(locationManager.distance)
                    }
                }
                
                let locationToken = aNewValue.observe(\.locationsList) { locationManager, change in
                    let locationsList = locationManager.locationsList
                    if let rootView = self.rootView,
                       let recentCoordinate = locationsList.last?.coordinate
                    {
                        let initialLocation = locationsList.count > 1 ?
                               locationsList[locationsList.count - 2] : nil
                        rootView.updateLocation(fromCoordinate : initialLocation?.coordinate,
                                                toCoordinate   : recentCoordinate)
                    }
                }
                
                KVOTokens.append(distanceToken)
                KVOTokens.append(locationToken)
            }
        }
    }
    
    private var rootView : VMWalkView? {
        return viewIfLoaded as? VMWalkView
    }
    
    private var KVOTokens = [NSKeyValueObservation]()
    
    //MARK:- Interface Handling
    @IBAction func onStartWalkButton(_ sender: Any) {
        if let walk = walk {
            saveWalk()
            stopWalk()
            
            let storyboard = UIStoryboard(name   : "Main",
                                          bundle : nil)
            
            if let navigationController = navigationController,
               let destinationVC = storyboard.instantiateViewController(withIdentifier: "VMEndWalkViewController") as? VMEndWalkViewController
            {
                destinationVC.walk = walk
                navigationController.pushViewController(destinationVC,
                                                        animated: true)
            }
        } else {
            startWalk()
        }
    }
    
    //MARK:- Helpers
    private func removeObservers() {
        for token in KVOTokens {
            token.invalidate()
        }
        
        KVOTokens = [NSKeyValueObservation]()
    }
    
    private func saveWalk() {
        walk!.duration = stopwatch.counter
        walk!.distance = locationManager.distance
    }
    
    private func stopWalk() {
        stopwatch.stop()
        locationManager.stop()
        locationManager = nil
        stopwatch = nil
        walk = nil
        
        removeObservers()
        
        rootView?.update(isWalkRunning: false)
    }
    
    private func startWalk() {
        walk = VMWalk(context: VMCoreDataStack.context)
        locationManager = VMLocationManager()
        stopwatch = VMStopwatch()
        
        rootView?.update(isWalkRunning: true)
    }
    
    //MARK:- MKMapViewDelegate
    func mapView(_ mapView          : MKMapView,
                 rendererFor overlay: MKOverlay) -> MKOverlayRenderer
    {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = .blue
        renderer.lineWidth = 3
        
        return renderer
    }
    
    private var isMapCentered : Bool = false
    
    func mapView(_ mapView              : MKMapView,
                 didUpdate userLocation : MKUserLocation)
    {
        if !isMapCentered {
            let region = MKCoordinateRegion(center             : userLocation.coordinate,
                                            latitudinalMeters  : 800,
                                            longitudinalMeters : 800)
            mapView.setRegion(region, animated: true)
            
            isMapCentered = true
            mapView.showsUserLocation = true
        }
    }
    
    func mapViewDidStopLocatingUser(_ mapView: MKMapView) {
        mapView.removeOverlays(mapView.overlays)
    }
}
