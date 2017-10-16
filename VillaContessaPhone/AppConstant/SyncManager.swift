//
//  SyncManager.swift
//  Villa Contessa Phone
//
//  Created by Nimble Chapps on 5/5/17.
//  Copyright © 2017 Nimblechapps. All rights reserved.
//

import UIKit
import TwilioSyncClient 
import Firebase

class SyncManager: NSObject {
    static let shared = SyncManager()
    fileprivate override init() {}
    
    var syncClient : TwilioSyncClient?
    
    var identity : String?
    var accessToken : String?
    
    func login() {
        if self.syncClient != nil {
            logout()
        }
        
        let token = generateToken()
        let properties = TwilioSyncClientProperties()
        if let token = token {
            self.syncClient = TwilioSyncClient(token: token,
                                               properties: properties,
                                               delegate: self)
        }
    }
    
    func logout() {
        if let syncClient = syncClient {
            syncClient.shutdown()
            self.syncClient = nil
        }
    }
    
    func generateToken() -> String? {
        if !ApplicationData.shared.isReachable {
            return nil
        }
        
        var urlString = String(format:"\(baseURLString)\(accessTokenEndpoint)")
        urlString += String(format:"?id=\(User_1)")
        
        var token : String?
        
        do {
            if let url = URL(string: urlString),
                let data = try? Data(contentsOf: url),
                let result = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] {
                token = result["token"] as? String
                accessToken = token
                identity = result["identity"] as? String
            }
        }
        catch {
            NSLog("Error obtaining Twilio token: %@",error.localizedDescription)
        }
        NSLog("Twilio Token: %@",String(describing: accessToken))
        FIRAnalytics.logEvent(withName: "generateToken", parameters: ["generateToken" : token! as NSObject])
        
        return token
    }
}

extension SyncManager : TwilioSyncClientDelegate {
    
}
