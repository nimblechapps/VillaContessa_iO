//
//  TVOCallInvite.h
//  TwilioVoice
//
//  Copyright © 2016-2017 Twilio, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TVOCall;
@protocol TVOCallDelegate;


/**
 * Enumeration indicating the state of the call invite.
 */
typedef NS_ENUM(NSUInteger, TVOCallInviteState) {
    TVOCallInviteStatePending = 0,      ///< The call invite is pending for action.
    TVOCallInviteStateAccepted,         ///< The call invite has been accepted.
    TVOCallInviteStateRejected,         ///< The call invite has been rejected.
    TVOCallInviteStateCanceled          ///< The call invite has been canceled by the caller.
};


/**
 * The `TVOCallInvite` object represents an incoming call invite. `TVOCallInvite` objects are 
 * not created directly; they are returned by the `<[TVONotificationDelegate callInviteReceived:]>`
 * delegate method.
 */
@interface TVOCallInvite : NSObject


/**
 * @name Properties
 */

/**
 * @brief `From` value of the call invite.
 */
@property (nonatomic, strong, readonly, nonnull) NSString *from;

/**
 * @brief `To` value of the call invite.
 */
@property (nonatomic, strong, readonly, nonnull) NSString *to;

/**
 * @brief `Call SID` value of the call invite.
 */
@property (nonatomic, strong, readonly, nonnull) NSString *callSid;

/**
 * @brief State of the call invite.
 *
 * @see TVOCallInviteState
 */
@property (nonatomic, assign, readonly) TVOCallInviteState state;

/**
 * @name Call Invite Actions
 */

/**
 * @brief Accepts the incoming call invite.
 *
 * @param delegate The `<TVOCallDelegate>` object that will receive call state updates.
 *
 * @return A `TVOCall` object.
 *
 * @see TVOCallDelegate
 */
- (nonnull TVOCall *)acceptWithDelegate:(nonnull id<TVOCallDelegate>)delegate;

/**
 * @brief Rejects the incoming call invite.
 */
- (void)reject;


- (null_unspecified instancetype)init __attribute__((unavailable("Incoming calls cannot be instantiated directly. See `TVONotificationDelegate`")));

@end


/**
 * CallKit Call Actions
 */
@interface TVOCallInvite (CallKitIntegration)

/**
 * @brief UUID of the call.
 *
 * @discussion Use this UUID for CallKit methods.
 */
@property (nonatomic, strong, readonly, nonnull) NSUUID *uuid;

@end
