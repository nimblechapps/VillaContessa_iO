//
//  AppConstant.swift
//  Villa Contessa Phone
//
//  Created by Nimble Chapps on 3/31/17.
//  Copyright © 2017 Nimblechapps. All rights reserved.
//

import Foundation
import UIKit

struct ScreenSize {
    static let ScreenWidth      = UIScreen.main.bounds.size.width
    static let ScreenHeight     = UIScreen.main.bounds.size.height
    static let ScreenMaxLength  = max(ScreenSize.ScreenWidth, ScreenSize.ScreenHeight)
    static let ScreenMinLength  = min(ScreenSize.ScreenWidth, ScreenSize.ScreenHeight)
}

struct DeviceType {
    static let isIphone4        = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.ScreenMaxLength < 568.0
    static let isIphone5        = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.ScreenMaxLength == 568.0
    static let isIphone6        = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.ScreenMaxLength == 667.0
    static let isIphone6P       = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.ScreenMaxLength == 736.0
    
    static let isIpad           = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.ScreenMaxLength == 1024.0
    static let isIpadPro        = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.ScreenMaxLength == 1366.0
}

struct Version {
    static let SystemVersion    = (UIDevice.current.systemVersion as NSString).floatValue
    static let iOS7             = (Version.SystemVersion < 8.0 && Version.SystemVersion >= 7.0)
    static let iOS8             = (Version.SystemVersion >= 8.0 && Version.SystemVersion < 9.0)
    static let iOS9             = (Version.SystemVersion >= 9.0 && Version.SystemVersion < 10.0)
    static let iOS10            = (Version.SystemVersion >= 10.0 && Version.SystemVersion < 11.0)
}

let appDelegate = UIApplication.shared.delegate as! AppDelegate

let userDefaults = UserDefaults.standard

let isIpad = (UIDevice.current.userInterfaceIdiom == .pad)

func RGBA(r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) -> UIColor {
    return UIColor.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}

func backgroundColor() -> UIColor {
    return RGBA(r: 241, g: 241, b: 241, a: 1.0)
}

// static key
let baseURLString           = "http://projects.developmentshowcase.com/calltest"
let accessTokenEndpoint     = "/generateToken.php"
let registerTokenEndpoint   = "/savetoken.php"
let callingStatus           = "/twiliostatus.php"

let kNoInternet             = "The Internet connection appears to be offline."
let kInValidAccessToken     = "Something goes wrong please try after some time."

let User_1 = "+4933614929002"
//let User_1 = "+4933614929001"
//let User_2 = "+4933614929002"
//let User_3 = "+4933614929003"
//let User_4 = "+4933614929004"
//let User_5 = "+4933614929005"
//let User_6 = "+4933614929006"
//let User_7 = "+4933614929007"
//let User_8 = "+4933614929008"

//let Reception = "+4933614929006"
//let Restaurant = "+4933614929007"

let Reception = "+493363158018"
let Restaurant = "+493363158018"

//let Reception = "+493363158018"
//let Restaurant = "+491773141473"

// Enum
enum CallerType: Int {
    case    other = 0
    case    reception
    case    restaurant
    case    room_1
    case    room_2
    case    room_3
    case    room_4
    case    room_5
    case    room_6
    case    room_7
    case    room_8
    case    room_9
    case    room_10
}

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
