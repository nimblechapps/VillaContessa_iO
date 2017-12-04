//
//  TwilioVoice.h
//  TwilioVoice
//
//  Copyright © 2016-2017 Twilio, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TVOCall;
@protocol TVOCallDelegate;
@protocol TVONotificationDelegate;

/**
 * Enumeration indicating the SDK’s logging level.
 */
typedef NS_ENUM(NSUInteger, TVOLogLevel) {
    TVOLogLevelOff = 0,     ///< Disables all SDK logging.
    TVOLogLevelError,       ///< Show errors only.
    TVOLogLevelWarn,        ///< Show warnings as well as all **Error** log messages.
    TVOLogLevelInfo,        ///< Show informational messages as well as all **Warn** log messages.
    TVOLogLevelDebug,       ///< Show debugging messages as well as all **Info** log messages.
    TVOLogLevelVerbose      ///< Show low-level debugging messages as well as all **Debug** log messages.
};

/**
 * `TwilioVoice` logging modules.
 */
typedef NS_ENUM(NSUInteger, TVOLogModule) {
    TVOLogModulePJSIP = 0,  ///< PJSIP Module
};

/**
 * The `TwilioVoice` is the entry point for interaction with the Twilio service.
 */
@interface TwilioVoice : NSObject

/**
 * @brief Logging level of the SDK.
 *
 * @discussion The default logging level of the SDK is `TVOLogLevelError`.
 *
 * @see TVOLogLevel
 */
@property (nonatomic, assign, class) TVOLogLevel logLevel;

/**
 * @brief The region (Twilio data center) for the SDK.
 *
 * @discussion The default region uses Global Low Latency routing, which establishes a connection 
 * with the closest region to the user. ***Note:*** Setting the region during a call will not apply
 * until all ongoing calls have ended and a subsequent call is placed.
 */
@property (nonatomic, copy, nonnull, class) NSString *region;

/**
 * @brief Returns the version of the SDK.
 *
 * @return The version of the SDK.
 */
+ (nonnull NSString *)version;

/**
 * @brief Sets logging level for an individual module.
 *
 * @param module The `<TVOLogModule>` for which the logging level is to be set.
 * @param level The `<TVOLogLevel>` level to be used by the module.
 *
 * @see TVOLogModule
 * @see TVOLogLevel
 */
+ (void)setModule:(TVOLogModule)module
         logLevel:(TVOLogLevel)level;

/**
 * @name Managing VoIP Push Notifications
 */

/**
 * @brief Registers for Twilio VoIP push notifications.
 *
 * @param accessToken Twilio Access Token.
 * @param deviceToken The push registry token for Apple VoIP Service.
 * @param completion Callback block to receive the result of the registration.
 */
+ (void)registerWithAccessToken:(nonnull NSString *)accessToken
                    deviceToken:(nonnull NSString *)deviceToken
                     completion:(nullable void(^)(NSError * __nullable error))completion;

/**
 * @brief Unregisters from Twilio VoIP push notifications.
 *
 * @param accessToken Twilio Access Token.
 * @param deviceToken The push registry token for Apple VoIP Service.
 * @param completion Callback block to receive the result of the unregistration.
 */
+ (void)unregisterWithAccessToken:(nonnull NSString *)accessToken
                      deviceToken:(nonnull NSString *)deviceToken
                       completion:(nullable void(^)(NSError * __nullable error))completion;

/**
 * @brief Processes the incoming VoIP push notification payload.
 *
 * @param payload Push notification payload.
 * @param delegate A `<TVONotificationDelegate>` to receive incoming call callbacks.
 *
 * @see TVONotificationDelegate
 */
+ (void)handleNotification:(nonnull NSDictionary *)payload
                  delegate:(nonnull id<TVONotificationDelegate>)delegate;

/**
 * @name Making Outgoing Calls
 */

/**
 * @brief Makes an outgoing call.
 *
 * @param accessToken Twilio Access Token.
 * @param twiMLParams Additional parameters to be passed to the TwiML application.
 * @param delegate A `<TVOCallDelegate>` to receive call state updates.
 *
 * @return A `<TVOCall>` object.
 *
 * @see TVOCall
 * @see TVOCallDelegate
 */
+ (nonnull TVOCall *)call:(nonnull NSString *)accessToken
                   params:(nullable NSDictionary <NSString *, NSString *> *)twiMLParams
                 delegate:(nonnull id<TVOCallDelegate>)delegate;


- (null_unspecified instancetype)init __attribute__((unavailable("TwilioVoice cannot be instantiated directly.")));

@end


/**
 * CallKit Audio Session Handling
 */
@interface TwilioVoice (CallKitIntegration)

/**
 * @brief Makes an outgoing call.
 *
 * @param accessToken Twilio Access Token.
 * @param twiMLParams Additional parameters to be passed to the TwiML application.
 * @param uuid An `NSUUID` used to uniquely identify this Call and suitable for sharing with `CXCallController`.
 * @param delegate A `<TVOCallDelegate>` to receive call state updates.
 *
 * @return A `<TVOCall>` object.
 *
 * @see TVOCall
 * @see TVOCallDelegate
 */
+ (nonnull TVOCall *)call:(nonnull NSString *)accessToken
                   params:(nullable NSDictionary <NSString *, NSString *> *)twiMLParams
                     uuid:(nonnull NSUUID *)uuid
                 delegate:(nonnull id<TVOCallDelegate>)delegate;

/**
 * @brief Configures, but does not activate the `AVAudioSession`.
 *
 * @discussion The application needs to use this method to set up the AVAudioSession with 
 * desired configuration before letting the CallKit framework activate the audio session.
 */
+ (void)configureAudioSession NS_AVAILABLE_IOS(10_0);

/**
 * @brief Starts the audio device.
 *
 * @discussion The application needs to use this method to signal the SDK to start audio
 * I/O units when receiving the audio activation callback of CXProviderDelegate.
 */
+ (void)startAudio NS_AVAILABLE_IOS(10_0);

/**
 * @brief Stops the audio device.
 *
 * @discussion The application needs to use this method to signal the SDK to stop audio
 * I/O units when receiving the deactivation or reset callbacks of CXProviderDelegate.
 */
+ (void)stopAudio NS_AVAILABLE_IOS(10_0);

@end
