//
//  VMWalkView.swift
//  VMWalk
//
//  Created by Varvara Myronova on 17.01.2022.
//

import UIKit
import MapKit

class VMWalkView: UIView {
    @IBOutlet var walkMapView       : MKMapView!
    @IBOutlet var startWalkButton   : UIButton!
    @IBOutlet var timestampLabel    : UILabel!
    @IBOutlet var distanceLabel     : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func updateStopWatch(_ seconds: Int64) {
        let formattedTime = FormatDisplay.time(Int(seconds))
        timestampLabel.text = String(formattedTime)
    }
    
    func updateDistance(_ distance: Double) {
        let distanceInMeters = FormatDisplay.distance(distance)
        distanceLabel.text = "\(distanceInMeters)"
    }
    
    func updateLocation(fromCoordinate : CLLocationCoordinate2D?,
                        toCoordinate   : CLLocationCoordinate2D)
    {
        let region = MKCoordinateRegion(center             : toCoordinate,
                                        latitudinalMeters  : 800,
                                        longitudinalMeters : 800)
        walkMapView.setRegion(region, animated: true)
        
        if let fromCoordinate = fromCoordinate {
            walkMapView.addOverlay(MKPolyline(coordinates : [fromCoordinate, toCoordinate],
                                              count       : 2))
        }
    }
    
    func update(isWalkRunning: Bool) {
        if isWalkRunning {
            startWalkButton.setTitle("STOP", for: .normal)
        } else {
            startWalkButton.setTitle("START", for: .normal)
            walkMapView.removeOverlays(walkMapView.overlays)
        }
    }
}
