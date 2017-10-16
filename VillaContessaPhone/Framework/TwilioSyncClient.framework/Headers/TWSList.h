//
//  TWSList.h
//  Twilio Sync Client
//
//  Copyright (c) 2017 Twilio, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWSConstants.h"
#import "TWSListItem.h"
#import "TWSListQueryOptions.h"

@protocol TWSListDelegate;
@class TWSError;

/** An ordered list of data within Sync. */
@interface TWSList : NSObject

/** The unique identifier for this list.
 
 @return The identifier.
 */
- (nonnull NSString *)sid;

/** The unique name for this list.
 
 @return The unique name.
 */
- (nullable NSString *)uniqueName;

/** Adds a new item to the list with the provided data.

 @param data The new data.
 @param flowId A developer specified identifier for this remote request.
 @param completion Completion block that will specify the result of the operation and the index of the newly added item.
 */
- (void)addItemWithData:(nonnull TWSData *)data
                 flowId:(NSUInteger)flowId
             completion:(nullable TWSListItemIndexCompletion)completion;

/** Request the list item at the specified index.
 
 @param index The index of the item to retrieve.
 @param flowId A developer specified identifier for this remote request.
 @param completion Completion block that will specify the result of the operation and the requested item if it exists.
 */
- (void)getItemAtIndex:(TWSItemIndex)index
                flowId:(NSUInteger)flowId
            completion:(nonnull TWSListItemCompletion)completion;

/** Sets the item at the specified index.
 
 @param index The index of the existing item to set.
 @param data The new data.
 @param flowId A developer specified identifier for this remote request.
 @param completion Completion block that will specify the result of the operation.
 */
- (void)setItemAtIndex:(TWSItemIndex)index
                  data:(nonnull TWSData *)data
                flowId:(NSUInteger)flowId
            completion:(nullable TWSCompletion)completion;

/** Modify the ListItem's data in a conflict-friendly way.
 
 @param index The index of the existing item to mutate.
 @param mutator The mutator that you provide to modify the data passed in.
 @param flowId A developer specified identifier for this remote request.
 @param completion Completion block that will specify the result of the operation.
 */
- (void)mutateItemAtIndex:(TWSItemIndex)index
                  mutator:(nonnull TWSDataMutator)mutator
                   flowId:(NSUInteger)flowId
               completion:(nullable TWSListItemCompletion)completion;

/** Removes the ListItem at the specified index.
 
 @param index The index of the item to remove.
 @param flowId A developer specified identifier for this remote request.
 @param completion Completion block that will specify the result of the operation.
 */
- (void)removeItemAtIndex:(TWSItemIndex)index
                   flowId:(NSUInteger)flowId
               completion:(nullable TWSCompletion)completion;

/** Query the list's items with the requested parameters.
 
 @param listQueryOptions The options for the list query.
 @param completion Completion block that will specify the result of the operation and a paginator for this page of results.
 */
- (void)queryItemsWithOptions:(nonnull TWSListQueryOptions *)listQueryOptions
                   completion:(nonnull TWSListPaginatorCompletion)completion;

/** Remove the list from the system, deleting it.
 
 @param flowId A developer specified identifier for this remote request.
 @param completion Completion block that will specify the result of the operation.
 */
- (void)removeListWithFlowId:(NSUInteger)flowId
                  completion:(nullable TWSCompletion)completion;

@end

/** The delegate that will be called with lifecycle updates for the list. */
@protocol TWSListDelegate<NSObject>
@optional

/** Called when the list referenced is opened.
 
 @param list The list.
 */
- (void)onListResultOpened:(nonnull TWSList *)list;

/** Called when a list item is added as a result of a local operation.
 
 @param list The list.
 @param itemIndex The index of the item.
 @param flowId A developer specified identifier for this remote request.
 */
- (void)onList:(nonnull TWSList *)list resultItemAddedAtIndex:(TWSItemIndex)itemIndex forFlowID:(NSUInteger)flowId;

/** Called when the list item at the specified index is removed as a result of a local operation.
 
 @param list The list.
 @param itemIndex The index of the item.
 @param flowId A developer specified identifier for this remote request.
 */
- (void)onList:(nonnull TWSList *)list resultItemRemovedAtIndex:(TWSItemIndex)itemIndex forFlowID:(NSUInteger)flowId;

/** Called when the list item at the specified index is updated as a result of a local operation.
 
 @param list The list.
 @param itemIndex The index of the item.
 @param flowId A developer specified identifier for this remote request.
 */
- (void)onList:(nonnull TWSList *)list resultItemUpdatedAtIndex:(TWSItemIndex)itemIndex forFlowID:(NSUInteger)flowId;

/** Called when an error occurs as a result of a local operation.
 
 @param list The list.
 @param error The error encounted.
 @param flowId A developer specified identifier for this remote request.
 */
- (void)onList:(nullable TWSList *)list resultErrorOccurred:(nonnull TWSError *)error forFlowID:(NSUInteger)flowId;

/** Called when the list is removed as a result of a local operation.
 
 @param list The list.
 @param flowId A developer specified identifier for this remote request.
 */
- (void)onList:(nonnull TWSList *)list resultCollectionRemovedForFlowID:(NSUInteger)flowId;

/** Called when a list item is added as a result of a remote operation.
 
 @param list The list.
 @param itemIndex The index of the item.
 @param item The item.
 */
- (void)onList:(nonnull TWSList *)list remoteItemAddedAtIndex:(TWSItemIndex)itemIndex item:(nonnull TWSListItem *)item;

/** Called when a list item is updated as a result of a remote operation.
 
 @param list The list.
 @param itemIndex The index of the item.
 @param item The item.
 */
- (void)onList:(nonnull TWSList *)list remoteItemUpdatedAtIndex:(TWSItemIndex)itemIndex item:(nonnull TWSListItem *)item;

/** Called when a list item is removed as a result of a remote operation.
 
 @param list The list.
 @param itemIndex The index of the item.
 */
- (void)onList:(nonnull TWSList *)list remoteItemRemovedAtIndex:(TWSItemIndex)itemIndex;

/** Called when the list is removed as a result of a remote operation.
 
 @param list The list.
 */
- (void)onListRemoteCollectionRemoved:(nonnull TWSList *)list;

/** Called when an error occurs as a result of a remote operation.
 
 @param list The list.
 @param error The error encounted.
 */
- (void)onList:(nonnull TWSList *)list remoteErrorOccurred:(nullable TWSError *)error;
@end
