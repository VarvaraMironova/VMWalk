//
//  VMWatchWalkController.swift
//  VMWatchWalk Extension
//
//  Created by Varvara Myronova on 25.01.2022.
//

import WatchKit
import Foundation

class VMWatchWalkController: WKInterfaceController {
    @IBOutlet var stopwatchLabel : WKInterfaceLabel!
    @IBOutlet var distanceLabel  : WKInterfaceLabel!
    @IBOutlet var endWalkButton  : WKInterfaceButton!
    
    var walk            : VMWalk!
    var stopwatch       : VMStopwatch? {
        willSet(aNewValue) {
            if let aNewValue = aNewValue {
                let stopWatchToken = aNewValue.observe(\.counter) { stopwatch, change in
                    self.fillStopwatchLabel(aNewValue.counter)
                }
                
                KVOTokens.append(stopWatchToken)
            }
        }
    }
    
    var locationManager : VMLocationManager? {
        willSet(aNewValue) {
            if let aNewValue = aNewValue {
                let distanceToken = aNewValue.observe(\.distance) { locationManager, change in
                    self.fillDistanceLabel(aNewValue.distance)
                }
                
                KVOTokens.append(distanceToken)
            }
        }
    }
    
    private var KVOTokens = [NSKeyValueObservation]()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        startWalk()
    }
    
    override func willDisappear() {
        stopWalk()
        
        super.willDisappear()
    }
    
    //MARK: - Interface Handlers
    @IBAction func onEndWalkButton() {
        pop()
    }
    
    //MARK: - Helpers
    private func startWalk() {
        walk = VMWalk(context: VMCoreDataStack.context)
        locationManager = VMLocationManager()
        stopwatch = VMStopwatch()
    }
    
    private func stopWalk() {
        stopwatch?.stop()
        locationManager?.stop()
        locationManager = nil
        stopwatch = nil
        walk = nil
        
        removeObservers()
    }
    
    private func fillStopwatchLabel(_ seconds: Int64) {
        let formattedTime = FormatDisplay.time(Int(seconds))
        stopwatchLabel.setText(formattedTime)
    }
    
    private func fillDistanceLabel(_ distance: Double) {
        let distanceInMeters = FormatDisplay.distance(distance)
        distanceLabel.setText("\(distanceInMeters)")
    }
    
    
    private func removeObservers() {
        for token in KVOTokens {
            token.invalidate()
        }
        
        KVOTokens = [NSKeyValueObservation]()
    }
    
}
