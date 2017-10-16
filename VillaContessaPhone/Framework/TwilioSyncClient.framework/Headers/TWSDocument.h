//
//  TWSDocument.h
//  Twilio Sync Client
//
//  Copyright (c) 2017 Twilio, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWSConstants.h"

@protocol TWSDocumentDelegate;
@class TWSError;

/** A document is the simplest Sync primitive that encapsulates a single JSON encoded object. */
@interface TWSDocument : NSObject

/** The unique identifier for this document.
 
 @return The identifier.
 */
- (nonnull NSString *)sid;

/** The unique name for this document.
 
 @return The unique name.
 */
- (nullable NSString *)uniqueName;

/** Obtain a snapshot of the document's current data.
 
 @return NSDictionary containing the data.
 */
- (nonnull TWSData *)getData;

/** Update the value of the document's data.
 
 @param data The new data.
 @param flowId A developer specified identifier for this remote request.
 @param completion Completion block that will specify the result of the operation.
 */
- (void)setData:(nonnull TWSData *)data
         flowId:(NSUInteger)flowId
     completion:(nullable TWSCompletion)completion;

/** Modify the Document's data in a conflict-friendly way.
 
 @param mutator The mutator that you provide to modify the data passed in.
 @param flowId A developer specified identifier for this remote request.
 @param completion Completion block that will specify the result of the operation and the updated value of the data.
 */
- (void)mutateDataWith:(nonnull TWSDataMutator)mutator
                flowId:(NSUInteger)flowId
            completion:(nullable TWSDataCompletion)completion;

/** Remove the document from the system, deleting it.
 
 @param flowId A developer specified identifier for this remote request.
 @param completion Completion block that will specify the result of the operation.
 */
- (void)removeDocumentWithFlowId:(NSUInteger)flowId
                      completion:(nullable TWSCompletion)completion;

@end

/** The delegate that will be called with lifecycle updates for the document. */
@protocol TWSDocumentDelegate<NSObject>
@optional
/** Called when the document referenced is opened.
 
 @param document The document.
 */
- (void)onDocumentResultOpened:(nonnull TWSDocument *)document;

/** Called when the document is removed as a result of a local operation.
 
 @param document The document.
 @param flowId A developer specified identifier for this remote request.
 */
- (void)onDocument:(nonnull TWSDocument *)document resultRemovedForFlowID:(NSUInteger)flowId;

/** Called when the document is modified as a result of a local operation.
 
 @param document The document.
 @param data The updated data for the document.
 @param flowId A developer specified identifier for this remote request.
 */
- (void)onDocument:(nonnull TWSDocument *)document resultDataUpdated:(nonnull TWSData *)data forFlowID:(NSUInteger)flowId;

/** Called when an error occurs as a result of a local operation.
 
 @param document The document.
 @param error The error encounted.
 @param flowId A developer specified identifier for this remote request.
 */
- (void)onDocument:(nullable TWSDocument *)document resultErrorOccurred:(nonnull TWSError *)error forFlowID:(NSUInteger)flowId;

/** Called when the document is modified as a result of a remote operation.
 
 @param document The document.
 @param data The updated data for the document.
 */
- (void)onDocument:(nonnull TWSDocument *)document remoteUpdated:(nonnull TWSData *)data;

/** Called when the document is removed as a result of a remote operation.
 
 @param document The document.
 */
- (void)onDocumentRemoteRemoved:(nonnull TWSDocument *)document;

/** Called when an error occurs as a result of a remote operation.
 
 @param document The document.
 @param error The error encounted.
 */
- (void)onDocument:(nonnull TWSDocument *)document remoteErrorOccurred:(nonnull TWSError *)error;
@end
