//
//  SyncManager.swift
//  Villa Contessa Phone
//
//  Created by Nimble Chapps on 5/5/17.
//  Copyright © 2017 Nimblechapps. All rights reserved.
//

import UIKit
import Firebase

class SyncManager: NSObject {
    static let shared = SyncManager()
    
    var identity : String?
    
    // MARK: - Initializer
    private override init() {
        super.init()
        User_1 = setNumber()
    }
    
    func generateToken() -> String? {
        //if !ApplicationData.shared.isReachable {
            //return nil
        //}
        
        var urlString = String(format:"\(baseURLString)\(accessTokenEndpoint)")
        urlString += String(format:"?id=\(User_1)")
        
        var token : String?
        
        do {
            if let url = URL(string: urlString),
                let data = try? Data(contentsOf: url),
                let result = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] {
                token = result["token"] as? String
                identity = result["identity"] as? String
            }
        }
        catch {
            NSLog("Error obtaining Twilio token: %@",error.localizedDescription)
            return nil
        }
        NSLog("Twilio Token: %@",String(describing: token))
        FIRAnalytics.logEvent(withName: "generateToken", parameters: ["generateToken" : token! as NSObject])
        
        return token
    }
    
    func setNumber() -> String {
        var deviceName = UIDevice.current.name
        NSLog("Device Name: %@",String(describing: deviceName))
        deviceName = deviceName.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        deviceName = deviceName.replacingOccurrences(of: "zimmer", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
        NSLog("Device number: %@",String(describing: deviceName))
        
        var number : String
        switch deviceName.lengthOfBytes(using: .utf8) {
        case 1:
            number = "+493361492900"+"\(deviceName)"
            break
        
        case 2:
            number = "+49336149290"+"\(deviceName)"
            break
        
        default:
            number = "+4933614929001"
            break
        }
        NSLog("Device phone number: %@",String(describing: number))
        return number
        
        /*
        switch deviceName {
        case "zimmer 1", "zimmer1":
            number = "+4933614929001"
            break
        case "zimmer 2", "zimmer2":
            number = "+4933614929002"
            break
        case "zimmer 3", "zimmer3":
            number = "+4933614929003"
            break
        case "Zimmer 4", "Zimmer4":
            number = "+4933614929004"
            break
        case "Zimmer 5", "Zimmer5":
            number = "+4933614929005"
            break
        case "Zimmer 6", "Zimmer6":
            number = "+4933614929006"
            break
        case "Zimmer 7", "Zimmer7":
            number = "+4933614929007"
            break
        case "Zimmer 8", "Zimmer8":
            number = "+4933614929008"
            break
        case "Zimmer 9", "Zimmer9":
            number = "+4933614929009"
            break
        case "Zimmer 10", "Zimmer10":
            number = "+4933614929010"
            break
        default:
            number = "+4933614929001"
            break
        }*/
    }
}
