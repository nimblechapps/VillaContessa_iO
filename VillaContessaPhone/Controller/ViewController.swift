//
//  ViewController.swift
//  Villa Contessa Phone
//
//  Created by Nimble Chapps on 2/11/17.
//  Copyright © 2017 Nimblechapps. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import UserNotifications
import PushKit
import TwilioVoice
import TwilioSyncClient
import Firebase

class ViewController: UIViewController, PKPushRegistryDelegate, AVAudioPlayerDelegate, TVONotificationDelegate, TVOCallDelegate {

    // MARK:- IBOutlet
    // For Room No.
    @IBOutlet weak var lblRoomNo: UILabel!
    
    // Display Reception View
    @IBOutlet weak var viewReception: UIView!
    @IBOutlet weak var lblReception: UILabel!
    @IBOutlet weak var lblReceptionSub: UILabel!
    @IBOutlet weak var btnReception: UIButton!
    @IBOutlet weak var imagePhoneReception: UIImageView!
    @IBOutlet weak var viewReceptionBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewReceptionHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageReceptionHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblReceptionTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblReceptionCenterConstraint: NSLayoutConstraint!
    
    // Display Restaurant View
    @IBOutlet weak var viewRestaurant: UIView!
    @IBOutlet weak var lblRestaurant: UILabel!
    @IBOutlet weak var lblRestaurantSub: UILabel!
    @IBOutlet weak var btnRestaurant: UIButton!
    @IBOutlet weak var imagePhoneRestaurant: UIImageView!
    @IBOutlet weak var viewRestaurantTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewRestaurantHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageRestaurantTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageRestaurantHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblRestaurantTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblRestaurantCenterConstraint: NSLayoutConstraint!
    
    // Display Accept/HangUp Call View
    @IBOutlet weak var viewCalling: UIView!
    @IBOutlet weak var dotLoaderCalling: DotsLoader!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var btnHangUp: UIButton!
    @IBOutlet weak var lblCalling: UILabel!
    
    // MARK: - Variables
    var callerType:CallerType = .reception
    
    var deviceTokenString:String?
    var voipRegistry: PKPushRegistry
    
    var callInvite:TVOCallInvite?
    var call:TVOCall?
    
    var ringtonePlayer: AVAudioPlayer?
    var ringtonePlaybackCallback: (() -> ())?
    
    // For Sync Call status
    var document : TWSDocument?
    var currentBoard = [String : Any]()
    
    // Font Name
    let fontName = "Garamond-Roman"    
    
    // MARK: - UIViewController Life Cycle
    required init?(coder aDecoder: NSCoder) {
        voipRegistry = PKPushRegistry.init(queue: DispatchQueue.main)
        
        super.init(coder: aDecoder)
        
        voipRegistry.delegate = self
        voipRegistry.desiredPushTypes = Set([PKPushType.voIP])
        
        TwilioVoice.sharedInstance().logLevel = .verbose
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NSLog("viewDidLoad")
        initialUI()
        
        self.lblRoomNo.text = ""
        currentBoard = emptyBoard()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NSLog("viewDidAppear")
        SyncManager.shared.login()
        getStatus()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setVolumeTo() {
        (MPVolumeView().subviews.filter{NSStringFromClass($0.classForCoder) == "MPVolumeSlider"}.first as? UISlider)?.setValue(1, animated: false)
    }
    
    // MARK: - Twilio Sync Data Method
    func getStatus() {
        NSLog("getStatus")
        let gameBoardName = SyncManager.shared.identity
        if let syncClient = SyncManager.shared.syncClient,
            let options = TWSOpenOptions.withUniqueName(gameBoardName!) {
            syncClient.openDocument(
                with: options,
                delegate: self,
                completion: { (result, document) in
                    if !(result?.isSuccessful())! {
                        NSLog("TTT: error creating document: %@", String(describing: result?.error?.localizedDescription))
                    } else {
                        self.document = document
                        self.updateBoardFromDocument()
                    }
            })
        }
    }
    
    func emptyBoard() -> [String: Any] {
        return ["date_updated":"\(Date())",
            "status": "none"]
    }
    
    func updateBoardFromDocument() {
        NSLog("updateBoardFromDocument")
        if let document = document {
            let data = document.getData()
            if let board = data["board"] as? [String: String] {
                self.currentBoard = board
                print("board : \(board)");
            }
            else {
                self.currentBoard = emptyBoard()
                updateDataOnBoard()
            }
            // Update UI
            DispatchQueue.main.async(execute: {
                if self.currentBoard["status"] as! String == "in-progress" {
                    self.callConnectedUI()
                }
//                else if self.currentBoard["status"] as! String == "no-answer" {
//                    self.call = nil
//                    self.callInvite = nil
//                    self.callEndedUI()
//                }
            })
        }
    }
    
    func updateDataOnBoard() {
        NSLog("updateDataOnBoard")
        let newData = ["board": self.currentBoard]
        document?.setData(newData, flowId: 1, completion: { (result) in
            if !(result?.isSuccessful())! {
                print("TTT: error updating the board: \(String(describing: result?.error))")
            }
        })
    }
    
    // MARK: - UI changes Method
    func initialUI() {
        NSLog("initialUI")
        FIRAnalytics.logEvent(withName: "initialUI", parameters: ["InitialUI" : "UI Reset" as NSObject])
        self.lblReception.text = "Rezeption"
        self.lblReceptionSub.text = "anrufen"
        self.imagePhoneReception.isHidden = false
        self.viewReceptionBottomConstraint.constant = 0
        self.viewReceptionHeightConstraint = self.viewReceptionHeightConstraint.setMultiplier(multiplier: 0.5)
        self.imageReceptionHeightConstraint.constant = 140
        self.lblReceptionTopConstraint.constant = 20
        self.lblReceptionCenterConstraint.constant = 5
        
        self.viewRestaurant.isHidden = false
        self.lblRestaurant.text = "Restaurant"
        self.lblRestaurantSub.text = "anrufen"
        self.imagePhoneRestaurant.isHidden = false
        self.viewRestaurantTopConstraint.constant = 0
        self.viewRestaurantHeightConstraint = self.viewRestaurantHeightConstraint.setMultiplier(multiplier: 0.5)
        self.imageRestaurantTopConstraint.constant = 24
        self.imageRestaurantHeightConstraint.constant = 140
        self.lblRestaurantTopConstraint.constant = 20
        self.lblRestaurantCenterConstraint.constant = 5
        
        self.viewCalling.isHidden = true
        self.dotLoaderCalling.isHidden = false
        self.btnAccept.isHidden = true
        self.btnHangUp.isHidden = false
        self.lblCalling.text = "Auflegen"
        
        self.lblRoomNo.isHidden = true
        
        toggleButtonState(isEnabled: true)
        
        self.lblRoomNo.font = UIFont(name: fontName, size: 18.0)
        
        self.lblReception.font = UIFont(name: fontName, size: 28.0)
        self.lblReceptionSub.font = UIFont(name: fontName, size: 24.0)
        
        self.lblRestaurant.font = UIFont(name: fontName, size: 28.0)
        self.lblRestaurantSub.font = UIFont(name: fontName, size: 24.0)
        
        self.lblCalling.font = UIFont(name: fontName, size: 24.0)
    }
    
    func toggleButtonState(isEnabled: Bool) {
        NSLog("toggleButtonState")
        self.btnReception.isEnabled = isEnabled
        self.btnRestaurant.isEnabled = isEnabled
        self.btnAccept.isEnabled = isEnabled
    }
    
    func callConnectedUI() {
        NSLog("callConnectedUI")
        FIRAnalytics.logEvent(withName: "callConnectedUI", parameters: ["ConnectedUI" : "Connected UI" as NSObject])
        self.dotLoaderCalling.isHidden = true
        switch callerType {
        case .reception:
            self.lblReception.text = "Rezeption"
            self.lblReceptionSub.text = "verbunden"
            break
            
        case .restaurant:
            self.lblRestaurant.text = "Restaurant"
            self.lblRestaurantSub.text = "verbunden"
            break
            
        case .other:
            self.lblReception.text = "Unbekannte Nummer"
            self.lblReceptionSub.text = "verbunden"
            break;
            
        default:
            break
        }
    }
    
    func callEndedUI() {
        NSLog("callEndedUI")
        FIRAnalytics.logEvent(withName: "callEndedUI", parameters: ["EndedUI" : "Ended UI" as NSObject])
        toggleButtonState(isEnabled: false)
        self.lblRoomNo.isHidden = false
        switch callerType {
        case .reception, .other:
            self.lblReceptionTopConstraint.constant = 30
            self.lblReception.text = "Anruf"
            self.lblReceptionSub.text = "beendet"
            self.viewRestaurant.isHidden = true
            self.viewCalling.isHidden = true
            break
            
        case .restaurant:
            self.lblRestaurantTopConstraint.constant = 30
            self.lblRestaurant.text = "Anruf"
            self.lblRestaurantSub.text = "beendet"
            self.viewRestaurant.isHidden = false
            self.viewCalling.isHidden = true
            break
            
        default:
            break
        }
        
        // Delay execution of my block for 2 seconds.
        let delayTime = DispatchTime.now() + 2 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            self.initialUI()
        }
    }
    
    func setRoomIdentity() {
        var identity = SyncManager.shared.identity
        identity = identity?.replacingOccurrences(of: "_", with: " ").components(separatedBy: " ").last
        self.lblRoomNo.text = "Zimmer"+" \(identity!)"
    }
    
    func showReceptionCall(isOut: Bool) {
        NSLog("showReceptionCall")
        FIRAnalytics.logEvent(withName: "showReceptionCall", parameters: ["ReceptionCall" : "Show Reception Call" as NSObject])
        self.callerType = .reception
        
        self.btnReception.isEnabled = false
        self.imagePhoneReception.isHidden = true
        self.dotLoaderCalling.startAnimating()
        
        if isOut {
            self.lblReception.text = "Rezeption"
            self.lblReceptionSub.text = "wird angerufen"
        }
        else {
            self.lblReception.text = "Rezeption"
            self.lblReceptionSub.text = "ruft an"
            
            self.btnAccept.isHidden = false
            self.btnHangUp.isHidden = true
            self.lblCalling.text = "Anruf annehmen"
        }
        
        self.viewReceptionBottomConstraint.constant = -28
        self.viewReceptionHeightConstraint = self.viewReceptionHeightConstraint.setMultiplier(multiplier: 0.55)
        self.imageReceptionHeightConstraint.constant = 180
        self.lblReceptionTopConstraint.constant = 30
        self.lblReceptionCenterConstraint.constant = 0
        
        self.lblReception.font = UIFont(name: fontName, size: 28.0)
        self.lblReceptionSub.font = UIFont(name: fontName, size: 28.0)
        
        self.viewRestaurant.isHidden = true
        self.viewCalling.isHidden = false
        setVolumeTo()
    }
    
    func showRestaurantCall(isOut: Bool) {
        NSLog("showRestaurantCall")
        FIRAnalytics.logEvent(withName: "showRestaurantCall", parameters: ["RestaurantCall" : "Show Restaurant Call" as NSObject])
        self.callerType = .restaurant
        
        self.btnRestaurant.isEnabled = false
        self.imagePhoneRestaurant.isHidden = true
        self.dotLoaderCalling.startAnimating()
        
        if isOut {
            self.lblRestaurant.text = "Restaurant"
            self.lblRestaurantSub.text = "wird angerufen"
        }
        else {
            self.lblRestaurant.text = "Restaurant"
            self.lblRestaurantSub.text = "ruft an"
            
            self.btnAccept.isHidden = false
            self.btnHangUp.isHidden = true
            self.lblCalling.text = "Anruf annehmen"
        }
        
        //self.viewRestaurantTopConstraint.constant = -284
        self.viewRestaurantTopConstraint.constant = -(self.view.frame.size.height / 2)
        self.viewRestaurantHeightConstraint = self.viewRestaurantHeightConstraint.setMultiplier(multiplier: 0.55)
        self.imageRestaurantTopConstraint.constant = 45
        self.imageRestaurantHeightConstraint.constant = 180
        self.lblRestaurantTopConstraint.constant = 30
        self.lblRestaurantCenterConstraint.constant = 0
        
        self.lblRestaurant.font = UIFont(name: fontName, size: 28.0)
        self.lblRestaurantSub.font = UIFont(name: fontName, size: 28.0)
        
        self.viewCalling.isHidden = false
        setVolumeTo()
    }
    
    // MARK: - IBAction Method
    @IBAction func receptionButtonTapped(_ sender: UIButton) {
        NSLog("receptionButtonTapped")
        FIRAnalytics.logEvent(withName: "receptionButtonTapped", parameters: ["ReceptionTapped" : "Reception Button Tapped" as NSObject])

        toggleButtonState(isEnabled: false)
        guard let accessToken = SyncManager.shared.generateToken() else {
            toggleButtonState(isEnabled: true)
            UIAlertController().alertControllerWithTitle(kInValidAccessToken, message: "", okButtonTitle: "OK", okBlockHandler: {
            }, viewController: self)
            return
        }
        
        setRoomIdentity()
        
        if (self.call != nil) {
            self.call?.disconnect()
        }
        
//        playOutgoingRingtone(completion: { [weak self] in
//            if let strongSelf = self {
                self.call = TwilioVoice.sharedInstance().call(accessToken, params: ["From":"\(User_1)", "To":"\(Reception)"], delegate: self)
                if (self.call == nil) {
                    NSLog("Failed to start outgoing reception call.")
                    self.toggleButtonState(isEnabled: true)
                    return
                }
                else {
                    showReceptionCall(isOut: true)
                }
//            }
//        })
        NSLog("restaurantButtonTapped: %@ To %@",User_1, Reception)
        FIRAnalytics.logEvent(withName: "receptionCall", parameters: ["ReceptionCallData" : "\(call.debugDescription)" as NSObject])
    }
    
    @IBAction func restaurantButtonTapped(_ sender: UIButton) {
        NSLog("restaurantButtonTapped")
        FIRAnalytics.logEvent(withName: "restaurantButtonTapped", parameters: ["RestaurantTapped" : "Restaurant Button Tapped" as NSObject])
        
        toggleButtonState(isEnabled: false)
        guard let accessToken = SyncManager.shared.generateToken() else {
            toggleButtonState(isEnabled: true)
            UIAlertController().alertControllerWithTitle(kInValidAccessToken, message: "", okButtonTitle: "OK", okBlockHandler: {
            }, viewController: self)
            return
        }
        
        setRoomIdentity()

        if (self.call != nil) {
            self.call?.disconnect()
        }
        
//        playOutgoingRingtone(completion: { [weak self] in
//            if let strongSelf = self {
                self.call = TwilioVoice.sharedInstance().call(accessToken, params: ["From":"\(User_1)", "To":"\(Restaurant)"], delegate: self)
                if (self.call == nil) {
                    NSLog("Failed to start outgoing restaurant call.")
                    self.toggleButtonState(isEnabled: true)
                    return
                }
                else {
                    showRestaurantCall(isOut: true)
                }
//            }
//        })
        NSLog("restaurantButtonTapped: %@ To %@",User_1, Restaurant)
        FIRAnalytics.logEvent(withName: "restaurantCall", parameters: ["RestaurantCallData" : "\(call.debugDescription)" as NSObject])
    }
    
    @IBAction func hangUpButtonTapped(_ sender: UIButton) {
        if (self.call != nil) {
            NSLog("outGoingCallhangUpTapped")
            FIRAnalytics.logEvent(withName: "outGoingCallTapped", parameters: ["OutGoingCallEnd" : "\(call.debugDescription)" as NSObject])
            DispatchQueue.main.async(execute: {
                // ON MAINTHREAD
                self.call?.disconnect()
            })
            toggleButtonState(isEnabled: false)
        }
        else if (self.callInvite != nil) {
            NSLog("inComingCallhangUpTapped")
            FIRAnalytics.logEvent(withName: "inComingCallTapped", parameters: ["InComingCallEnd" : "\(callInvite.debugDescription)" as NSObject])
            DispatchQueue.main.async(execute: {
                // ON MAINTHREAD
                self.callInvite?.reject()
                self.callInvite = nil
            })
        }
    }
    
    @IBAction func acceptButtonTapped(_ sender: UIButton) {
        NSLog("acceptButtonTapped")
        FIRAnalytics.logEvent(withName: "acceptButtonTapped", parameters: ["AcceptButtonTapped" : "\(callInvite.debugDescription)" as NSObject])
        self.stopIncomingRingtone(completion: {_ in
        })
        DispatchQueue.main.async(execute: {
            // ON MAINTHREAD
            self.callInvite!.accept(with: self)
            
            self.callConnectedUI()
            self.btnAccept.isHidden = true
            self.btnHangUp.isHidden = false
            self.lblCalling.text = "Auflegen"
        })
    }
    
    // MARK: - PKPushRegistryDelegate
    func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, forType type: PKPushType) {
        NSLog("pushRegistry:didUpdatePushCredentials:forType:")
        
        if (type != .voIP) {
            return
        }
        
        let deviceToken = (credentials.token as NSData).description
        
        guard let accessToken = SyncManager.shared.generateToken() else {
            return
        }
        
        setRoomIdentity()
        
        FIRAnalytics.logEvent(withName: "pushRegistrydidUpdate", parameters: ["PushRegistrydidUpdate" : "\(accessToken)" as NSObject])
        TwilioVoice.sharedInstance().register(withAccessToken: accessToken, deviceToken: deviceToken) { (error) in
            if (error != nil) {
                NSLog("An error occurred while registering: %@",String(describing: error?.localizedDescription))
            }
            else {
                NSLog("Successfully registered for VoIP push notifications.")
            }
        }
        
        self.deviceTokenString = deviceToken
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenForType type: PKPushType) {
        NSLog("pushRegistry:didInvalidatePushTokenForType:")
        
        if (type != .voIP) {
            return
        }
        
        guard let deviceToken = deviceTokenString, let accessToken = SyncManager.shared.generateToken() else {
            return
        }
        
        FIRAnalytics.logEvent(withName: "pushRegistrydidInvalidatePushTokenForType", parameters: ["PushRegistryDidInvalidatePushTokenForType" : "\(accessToken)" as NSObject])
        TwilioVoice.sharedInstance().unregister(withAccessToken: accessToken, deviceToken: deviceToken) { (error) in
            if (error != nil) {
                NSLog("An error occurred while unregistering: %@",String(describing: error?.localizedDescription))
            }
            else {
                NSLog("Successfully unregistered from VoIP push notifications.")
            }
        }
        
        self.deviceTokenString = nil
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, forType type: PKPushType) {
        NSLog("pushRegistry:didReceiveIncomingPushWithPayload:forType:")
        
        FIRAnalytics.logEvent(withName: "pushRegistrydidReceiveIncomingPushWith", parameters: ["PushRegistryDidReceiveIncomingPushWith" : "\(payload.dictionaryPayload)" as NSObject])
        if (type == .voIP) {
            TwilioVoice.sharedInstance().handleNotification(payload.dictionaryPayload, delegate: self)
        }
    }
    
    // MARK: - TVONotificationDelegate
    func callInviteReceived(_ callInvite: TVOCallInvite) {
        NSLog("callInviteReceived:")
        
        if (self.callInvite != nil && self.callInvite?.state == .pending) {
            NSLog("Already a pending call invite. Ignoring incoming call invite from %@",callInvite.from)
            return
        } else if (self.call != nil && self.call?.state == .connected) {
            NSLog("Already an active call. Ignoring incoming call invite from %@",callInvite.from)
            return;
        }
        
        self.callInvite = callInvite;
        
        let from = callInvite.from
        
        playIncomingRingtone()
        NSLog("callInviteReceived %@",callInvite.from)
        FIRAnalytics.logEvent(withName: "callInviteReceived", parameters: ["CallInviteReceived" : "\(callInvite.from)" as NSObject])
        if !from.isEmpty && from == Reception {
            showReceptionCall(isOut: false)
        }
            
        else if !from.isEmpty && from == Restaurant {
            showRestaurantCall(isOut: false)
        }
        
        else {
            showReceptionCall(isOut: false)
            callerType = .other
            self.lblReception.text = "Unbekannte Nummer"
        }
        
        // If the application is not in the foreground, post a local notification
        if (UIApplication.shared.applicationState != UIApplicationState.active) {
            if #available(iOS 10.0, *) {
                let content = UNMutableNotificationContent()
                content.title = ""
                content.body = "\(from) ruft an"
                content.sound = UNNotificationSound.default()
                content.badge = 0;
                
                // Deliver the notification in one seconds.
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
                
                let request = UNNotificationRequest(identifier: "Test", content: content, trigger: trigger)
                // 3. schedule localNotification
                let center = UNUserNotificationCenter.current()
                center.add(request, withCompletionHandler: { (error) in
                    if error == nil{
                        NSLog("add NotificationRequest succeeded!")
                    }
                })
            }
            else {
                // Fallback on earlier versions
                let notification = UILocalNotification()
                notification.alertBody = "\(from) ruft an"
                UIApplication.shared.presentLocalNotificationNow(notification)
            }
        }
    }
    
    func callInviteCancelled(_ callInvite: TVOCallInvite?) {
        NSLog("callInviteCancelled:")
        
        FIRAnalytics.logEvent(withName: "callInviteCancelled", parameters: ["CallInviteCancelled" : "\(String(describing: callInvite?.from))" as NSObject])
        if (callInvite?.callSid != self.callInvite?.callSid) {
            NSLog("Incoming (but not current) call invite from %@ cancelled. Just ignore it.", String(describing: callInvite?.from))
            return;
        }
        
        self.stopIncomingRingtone(completion: nil)
        
        self.callInvite = nil
        if #available(iOS 10.0, *) {
            UIApplication.shared.applicationIconBadgeNumber = 0
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        } else {
            // Fallback on earlier versions
            UIApplication.shared.applicationIconBadgeNumber = 0
            UIApplication.shared.cancelAllLocalNotifications()
        }
        
        callEndedUI()
    }
    
    func notificationError(_ error: Error) {
        NSLog("notificationError: %@",error.localizedDescription)
        FIRAnalytics.logEvent(withName: "notificationError", parameters: ["NotificationError" : "\(error.localizedDescription)" as NSObject])
        initialUI()
    }
    
    // MARK: TVOCallDelegate
    func callDidConnect(_ call: TVOCall) {
        NSLog("callDidConnect:")
        FIRAnalytics.logEvent(withName: "callDidConnect", parameters: ["CallDidConnect" : "\(call.debugDescription)" as NSObject])
        self.call = call
        
        toggleButtonState(isEnabled: true)
        routeAudioToSpeaker()
    }
    
    func callDidDisconnect(_ call: TVOCall) {
        NSLog("callDidDisconnect:")
        FIRAnalytics.logEvent(withName: "callDidDisconnect", parameters: ["CallDidDisconnect" : "\(call.debugDescription)" as NSObject])
        
        self.call = nil
        self.callInvite = nil
        
        callEndedUI()
    }
    
    func call(_ call: TVOCall, didFailWithError error: Error) {
        NSLog("call:didFailWithError: %@",error.localizedDescription)
        FIRAnalytics.logEvent(withName: "calldidFailWithError", parameters: ["CallDidFailWithError" : "\(error.localizedDescription)" as NSObject])
        
        self.call = nil
        self.callInvite = nil

        initialUI()
    }
    
    // MARK: - AVAudioSession
    func routeAudioToSpeaker() {
        do {
            try AVAudioSession.sharedInstance().overrideOutputAudioPort(.speaker)
        }
        catch let error as NSError {
            print("Failed to route audio to speaker: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Ringtone player & AVAudioPlayerDelegate
    func playOutgoingRingtone(completion: @escaping () -> ()) {
        self.ringtonePlaybackCallback = completion
        
        let ringtonePath = URL(fileURLWithPath: Bundle.main.path(forResource: "outgoing", ofType: "wav")!)
        do {
            self.ringtonePlayer = try AVAudioPlayer(contentsOf: ringtonePath)
            self.ringtonePlayer?.delegate = self
            playRingtone()
        }
        catch {
            print("Failed to load outgoing url: \(error.localizedDescription)")
            self.ringtonePlaybackCallback?()
        }
    }
    
    func playIncomingRingtone() {
        let ringtonePath = URL(fileURLWithPath: Bundle.main.path(forResource: "Klingelton-altes-Telefon", ofType: "mp3")!)
        do {
            self.ringtonePlayer = try AVAudioPlayer(contentsOf: ringtonePath)
            self.ringtonePlayer?.delegate = self
            self.ringtonePlayer?.numberOfLoops = -1
            playRingtone()
        }
        catch {
            print("Failed to load incoming url: \(error.localizedDescription)")
        }
    }
    
    func stopIncomingRingtone(completion: ((Void?) -> Void)?) {
        self.ringtonePlaybackCallback = completion
        if (self.ringtonePlayer?.isPlaying == false) {
            self.ringtonePlaybackCallback?()
            return
        }
        
        self.ringtonePlayer?.delegate = self
        self.ringtonePlayer?.numberOfLoops = 0
    }
    
    func playDisconnectSound() {
        let ringtonePath = URL(fileURLWithPath: Bundle.main.path(forResource: "disconnect", ofType: "wav")!)
        do {
            self.ringtonePlayer = try AVAudioPlayer(contentsOf: ringtonePath)
            self.ringtonePlayer?.delegate = self
            self.ringtonePlaybackCallback = nil
            playRingtone()
        }
        catch {
            print("Failed to load disconnect url: \(error.localizedDescription)")
        }
    }
    
    func playRingtone() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        }
        catch {
            print("Unable to reroute audio: \(error.localizedDescription)")
        }
        
        self.ringtonePlayer?.volume = 1
        self.ringtonePlayer?.play()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag:Bool) {
        if (self.ringtonePlaybackCallback != nil) {
            DispatchQueue.main.async {
                self.ringtonePlaybackCallback!()
            }
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
        }
        catch {
            print("Unable to reroute audio: \(error.localizedDescription)")
        }
    }
}

// MARK: - ViewController: TWSDocumentDelegate
extension ViewController: TWSDocumentDelegate {
    func onDocument(_ document: TWSDocument, resultDataUpdated data: [String : Any], forFlowID flowId: UInt) {
        self.document = document
        self.updateBoardFromDocument()
        print("TTT: document: \(document) data: \(data) flowId: \(flowId)")
    }
    
    func onDocument(_ document: TWSDocument, remoteUpdated data: [String : Any]) {
        self.document = document
        self.updateBoardFromDocument()
        print("TTT: document: \(document) data: \(data)")
    }
    
    func onDocument(_ document: TWSDocument, remoteErrorOccurred error: TWSError) {
        self.document = document
        print("TTT: document: \(document) error: \(error)")
    }
}

// MARK: - NSLayoutConstraint
extension NSLayoutConstraint {
    /**
     Change multiplier constraint
     - parameter multiplier: CGFloat
     - returns: NSLayoutConstraint
     */
    func setMultiplier(multiplier:CGFloat) -> NSLayoutConstraint {
        
        NSLayoutConstraint.deactivate([self])
        
        let newConstraint = NSLayoutConstraint(
            item: firstItem,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)
        
        newConstraint.priority = priority
        newConstraint.shouldBeArchived = self.shouldBeArchived
        newConstraint.identifier = self.identifier
        
        NSLayoutConstraint.activate([newConstraint])
        return newConstraint
    }
}
