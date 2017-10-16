//
//  ApplicationData.swift
//  Villa Contessa Phone
//
//  Created by Nimble Chapps on 3/31/17.
//  Copyright © 2017 Nimblechapps. All rights reserved.
//

import UIKit

class ApplicationData: NSObject {
    static let shared = ApplicationData()
    
    // Reachability
    var reachability: Reachability?
    let hostNames = [nil, "google.com", "invalidhost"]
    var hostIndex = 0
    var isReachable: Bool = false;
    
    // MARK: -
    private override init() {
        super.init()
        startHost(at: 0)
    }
    
    // MARK: - Reachability
    func startHost(at index: Int) {
        stopNotifier()
        setupReachability(hostNames[index], useClosures: true)
        startNotifier()
    }
    
    func setupReachability(_ hostName: String?, useClosures: Bool) {
        let reachability: Reachability?
        if let hostName = hostName {
            reachability = Reachability(hostname: hostName)
        } else {
            reachability = Reachability()
        }
        self.reachability = reachability
        
        if useClosures {
            reachability?.whenReachable = { reachability in
                self.updateLabelColourWhenReachable(reachability)
            }
            reachability?.whenUnreachable = { reachability in
                self.updateLabelColourWhenNotReachable(reachability)
            }
        }
        else {
            NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(_:)), name: .reachabilityChanged, object: reachability)
        }
    }
    
    func startNotifier() {
        NSLog("start notifier")
        do {
            try reachability?.startNotifier()
        } catch {
            return
        }
    }
    
    func stopNotifier() {
        NSLog("stop notifier")
        reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: nil)
        reachability = nil
    }
    
    func updateLabelColourWhenReachable(_ reachability: Reachability) {
        NSLog("%@", reachability.description)
        isReachable = true
    }
    
    func updateLabelColourWhenNotReachable(_ reachability: Reachability) {
        NSLog("%@", reachability.description)
        isReachable = false
    }
    
    @objc func reachabilityChanged(_ note: Notification) {
        let reachability = note.object as! Reachability
        
        if reachability.connection != .none {
            updateLabelColourWhenReachable(reachability)
        } else {
            updateLabelColourWhenNotReachable(reachability)
        }
    }
}
