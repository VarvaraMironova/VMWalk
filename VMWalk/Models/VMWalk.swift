//
//  VMWalk.swift
//  VMWalk
//
//  Created by Varvara Myronova on 20.01.2022.
//

import Foundation

extension VMWalk {
    enum KVMWalkState: Int16 {
        case running = 1
        case stopped = 2
        case underfined = 0
    }
    
    var state: KVMWalkState {
        get {
            return KVMWalkState(rawValue: stateValue)!
        }
        
        set {
            stateValue = newValue.rawValue
        }
    }
}
