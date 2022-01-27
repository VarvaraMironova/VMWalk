//
//  VMEndWalkViewController.swift
//  VMWalk
//
//  Created by Varvara Myronova on 17.01.2022.
//

import UIKit

class VMEndWalkViewController: UIViewController {
    var walk: VMWalk!
    
    //MARK: - View Life Cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let rootView = rootView {
            rootView.fill(walk)
        }
    }
    
    private var rootView : VMEndWalkView? {
        return viewIfLoaded as? VMEndWalkView
    }
    
    @IBAction func onEndWalkButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
}
