//
//  VMWatchStartWalkController.swift
//  VMWatchWalk Extension
//
//  Created by Varvara Myronova on 25.01.2022.
//

import WatchKit
import Foundation

class VMWatchStartWalkController: WKInterfaceController {

    override func awake(withContext context: Any?) {
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }

    @IBAction func onStartWalkButton() {
        print("walk started!")
    }
}
