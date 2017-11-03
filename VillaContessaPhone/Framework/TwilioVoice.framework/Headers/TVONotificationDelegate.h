//
//  TVONotificationDelegate.h
//  TwilioVoice
//
//  Copyright © 2016-2017 Twilio, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TVOCallInvite;

/**
 * The `TVONotificationDelegate`'s methods allow the delegate to be informed when
 * incoming call invites are received or canceled.
 */
@protocol TVONotificationDelegate <NSObject>

/**
 * @name Required Methods
 */

/**
 * @brief Notifies the delegate that a call invite was received.
 *
 * @discussion A call invite may be in the `TVOCallInviteStatePending` or 
 * `TVOCallInviteStateCanceled` state.
 *
 * @param callInvite A `<TVOCallInvite>` object.
 *
 * @see TVOCallInvite
 */
- (void)callInviteReceived:(nonnull TVOCallInvite *)callInvite;

/**
 * @brief Notifies the delegate that an error occurred when processing the `VoIP`
 * push notification payload.
 *
 * @param error An `NSError` object describing the error.
 */
- (void)notificationError:(nonnull NSError *)error;

@end
