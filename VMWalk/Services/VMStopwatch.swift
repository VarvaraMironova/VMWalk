//
//  VMStopwatch.swift
//  VMWalk
//
//  Created by Varvara Myronova on 20.01.2022.
//

import Foundation


class VMStopwatch: NSObject {
    private var timer     : Timer!
    private var isRunning = false
    
    //seconds counter
    @objc dynamic public var counter : Int64 = 0
    
    override init() {
        super.init()
        
        start()
    }
    
    deinit {
        timer.invalidate()
    }
    
    //MARK: - Public
    public func stop() {
        timer.invalidate()
        isRunning = false
        counter = 0
    }
    
    //MARK: - Helpers
    private func start() {
        if isRunning {
            return
        }
        
        timer = Timer.scheduledTimer(timeInterval : 1,
                                     target       : self,
                                     selector     : #selector(onTimer),
                                     userInfo     : nil,
                                     repeats      : true)
        
        isRunning = true
    }
    
    @objc private func onTimer() {
        counter += 1
    }
}
