//
//  VMEndWalkView.swift
//  VMWalk
//
//  Created by Varvara Myronova on 17.01.2022.
//

import UIKit

class VMEndWalkView: UIView {
    @IBOutlet var timeTitleLabel     : UILabel!
    @IBOutlet var distanceTitleLabel : UILabel!
    @IBOutlet var paceTitleLabel     : UILabel!
    
    @IBOutlet var timeLabel          : UILabel!
    @IBOutlet var distanceLabel      : UILabel!
    @IBOutlet var paceLabel          : UILabel!
    
    @IBOutlet var endLabelButton     : UIButton!
    
    public func fill(_ walk: VMWalk) {
        let formattedTime = FormatDisplay.time(Int(walk.duration))
        timeLabel.text = String(formattedTime)
        
        let distanceInMeters = FormatDisplay.distance(walk.distance)
        distanceLabel.text = "\(distanceInMeters)"
    }
}
