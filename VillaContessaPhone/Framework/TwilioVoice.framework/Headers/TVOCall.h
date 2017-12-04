//
//  TVOCall.h
//  TwilioVoice
//
//  Copyright © 2016-2017 Twilio, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TVOCallDelegate;

/**
 * Enumeration indicating the state of the call.
 */
typedef NS_ENUM(NSUInteger, TVOCallState) {
    TVOCallStateConnecting = 0, ///< The call is connecting.
    TVOCallStateConnected,      ///< The call is connected.
    TVOCallStateDisconnected    ///< The call is disconnected.
};


/**
 * The `TVOCall` object represents a call. `TVOCall` objects are not created directly; they
 * are returned by the `<[TVOCallInvite acceptWithDelegate:]>` method or the
 * `<[TwilioVoice call:params:delegate:]>` method.
 */
@interface TVOCall : NSObject


/**
 * @name Properties
 */

/**
 * @brief The `<TVOCallDelegate>` object that will receive call state updates.
 *
 * @see TVOCallDelegate
 */
@property (nonatomic, weak, nullable) id<TVOCallDelegate> delegate;

/**
 * @brief `From` value of the call.
 *
 * @discussion This may be `nil` if the call object was created by calling the 
 * `<[TwilioVoice call:params:delegate:]>` method.
 */
@property (nonatomic, strong, readonly, nullable) NSString *from;

/**
 * @brief `To` value of the call.
 *
 * @discussion This may be `nil` if the call object was created by calling the 
 * `<[TwilioVoice call:params:delegate:]>` method.
 */
@property (nonatomic, strong, readonly, nullable) NSString *to;

/**
 * @brief `Call SID` value of the call.
 */
@property (nonatomic, strong, readonly, nonnull) NSString *sid;

/**
 * @brief Property that defines if the call is muted.
 *
 * @discussion Setting the property will only take effect if the `<state>` is `TVOCallConnected`.
 */
@property (nonatomic, assign, getter=isMuted) BOOL muted;

/**
 * @brief State of the call.
 *
 * @see TVOCallState
 */
@property (nonatomic, assign, readonly) TVOCallState state;

/**
 * @brief Property that defines if the call is on hold.
 *
 * @discussion Holding a Call ceases the flow of audio between parties. This operation is performed
 * automatically in response to an AVAudioSession interruption. Setting the property will only take
 * effect if the `<state>` is `TVOCallConnected`.
 */
@property (nonatomic, getter=isOnHold) BOOL onHold;


/**
 * @name General Call Actions
 */

/**
 * @brief Disconnects the call.
 *
 * @discussion Calling this method on a `TVOCall` that does not have the `<state>` of `TVOCallStateConnected`
 * will have no effect.
 */
- (void)disconnect;

/**
 * @brief Send a string of digits.
 *
 * @discussion Calling this method on a `TVOCall` that does not have the `<state>` of `TVOCallStateConnected`
 * will have no effect.
 *
 * @param digits A string of characters to be played. Valid values are '0' - '9', '*', '#', and 'w'.
 *               Each 'w' will cause a 500 ms pause between digits sent.
 */
- (void)sendDigits:(nonnull NSString *)digits;


- (null_unspecified instancetype)init __attribute__((unavailable("Calls cannot be instantiated directly. See `TVOCallInvite acceptWithDelegate:` or `TwilioVoice call:params:delegate:`")));

@end


/**
 * CallKit Call Actions
 */
@interface TVOCall (CallKitIntegration)

/**
 * @brief UUID of the call.
 *
 * @discussion Use this UUID to identify the `TVOCall` when working with CallKit.
 * You can provide a UUID for outgoing calls using `[TwilioVoice call:params:uuid:delegate]`.
 * Calls created via `[TVOCallInvite acceptWithDelegate:]` inherit their `uuid` from the Invite itself.
 */
@property (nonatomic, strong, readonly, nonnull) NSUUID *uuid;

@end
