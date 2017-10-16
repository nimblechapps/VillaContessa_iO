//
//  TwilioSyncClient.h
//  Twilio Sync Client
//
//  Copyright (c) 2017 Twilio, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TWSConstants.h"
#import "TWSOpenOptions.h"

#import "TWSDocument.h"
#import "TWSList.h"
#import "TWSListItem.h"
#import "TWSListPaginator.h"
#import "TWSListQueryOptions.h"
#import "TWSMap.h"
#import "TWSMapItem.h"
#import "TWSMapPaginator.h"
#import "TWSMapQueryOptions.h"

@class TwilioSyncClientProperties;
@protocol TwilioSyncClientDelegate;

/** Represents a Sync client connection to Twilio. */
@interface TwilioSyncClient : NSObject

/** Sync client delegate */
@property (nonatomic, weak, nullable) id<TwilioSyncClientDelegate> delegate;

/** The client's current connection state. */
@property (nonatomic, assign, readonly) TWSClientConnectionState connectionState;

/** Initialize a new Sync client instance with a token manager.
 
 @param token The client access token to use when communicating with Twilio.
 @param properties The initialization parameter for the Sync client.
 @param delegate Delegate conforming to TwilioSyncClientDelegate for Sync client lifecycle notifications.
 @return New Sync client instance.
 */
+ (nullable TwilioSyncClient *)syncClientWithToken:(nonnull NSString *)token
                                        properties:(nullable TwilioSyncClientProperties *)properties
                                          delegate:(nullable id<TwilioSyncClientDelegate>)delegate;

/* Direct instantiation is not supported, please use convenience method. */
- (nonnull instancetype) init __attribute__((unavailable("please use syncClientWithToken:properties:delegate: to construct instead")));

/** Sets the logging level for the client.
 
 @param logLevel The new log level.
 */
+ (void)setLogLevel:(TWSLogLevel)logLevel;

/** The logging level for the client.
 
 @return The log level.
 */
+ (TWSLogLevel)logLevel;

/** Returns the version of the SDK
 
 @return The Sync client version.
 */
- (nonnull NSString *)version;

/** Updates the access token currently being used by the client.
 
 @param token The updated client access token to use when communicating with Twilio.
 */
- (void)updateToken:(nonnull NSString *)token;

/** Cleanly shut down the sync client when you are done with it. */
- (void)shutdown;

/** Open or create a document.
 
 @param options An instance of TSOptions which specify the document to open or create.
 @param delegate Delegate for operations related to this document.
 @param completion Completion block that will specify the result of the operation and a reference to the document.
 */
- (void)openDocumentWithOptions:(nonnull TWSOpenOptions *)options
                       delegate:(nonnull id<TWSDocumentDelegate>)delegate
                     completion:(nonnull TWSDocumentCompletion)completion;

/** Open or create a list.
 
 @param options An instance of TSOptions which specify the list to open or create.
 @param delegate Delegate for operations related to this list.
 @param completion Completion block that will specify the result of the operation and a reference to the list.
 */
- (void)openListWithOptions:(nonnull TWSOpenOptions *)options
                   delegate:(nonnull id<TWSListDelegate>)delegate
                 completion:(nonnull TWSListCompletion)completion;


/** Open or create a map.
 
 @param options An instance of TSOptions which specify the map to open or create.
 @param delegate Delegate for operations related to this map.
 @param completion Completion block that will specify the result of the operation and a reference to the map.
 */
- (void)openMapWithOptions:(nonnull TWSOpenOptions *)options
                  delegate:(nonnull id<TWSMapDelegate>)delegate
                completion:(nonnull TWSMapCompletion)completion;

@end

#pragma mark -

/** The initialization parameter for the Sync client. */
@interface TwilioSyncClientProperties : NSObject

/** The region of Sync to connect to, defaults to 'us1'.  Instanaces exist in specific regions, so this should only be changed if needed. */
@property (nonatomic, copy, nonnull) NSString *region;

@end

#pragma mark -

/** This protocol declares the Sync client delegate methods. */
@protocol TwilioSyncClientDelegate <NSObject>
@optional
/** Called when the client connection state changes.
 
 @param client The sync client.
 @param state The current connection state of the client.
 */
- (void)syncClient:(nonnull TwilioSyncClient *)client connectionStateChanged:(TWSClientConnectionState)state;

/** Called when an error occurs.
 
 @param client The sync client.
 @param error The error.
 */
- (void)syncClient:(nonnull TwilioSyncClient *)client errorReceived:(nonnull TWSError *)error;

@end
