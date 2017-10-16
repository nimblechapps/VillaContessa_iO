//
//  TWSMap.h
//  Twilio Sync Client
//
//  Copyright (c) 2017 Twilio, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWSConstants.h"
#import "TWSMapItem.h"
#import "TWSMapQueryOptions.h"

@protocol TWSMapDelegate;
@class TWSError;

/** A map stores unordered JSON objects accessible via a developer defined key. */
@interface TWSMap : NSObject

/** The unique identifier for this map.
 
 @return The identifier.
 */
- (nonnull NSString *)sid;

/** The unique name for this map.
 
 @return The unique name.
 */
- (nullable NSString *)uniqueName;

/** Request the map item with the specified key.
 
 @param key The key of the item to retrieve.
 @param flowId A developer specified identifier for this remote request.
 @param completion Completion block that will specify the result of the operation and the requested item if it exists.
 */
- (void)getItemWithKey:(nonnull NSString *)key
                flowId:(NSUInteger)flowId
            completion:(nonnull TWSMapItemCompletion)completion;

/** Sets the item for the specified key.
 
 @param key The key of the item to set.
 @param data The new data.
 @param flowId A developer specified identifier for this remote request.
 @param completion Completion block that will specify the result of the operation.
 */
- (void)setItemWithKey:(nonnull NSString *)key
                  data:(nonnull TWSData *)data
                flowId:(NSUInteger)flowId
            completion:(nullable TWSCompletion)completion;

/** Modify the MapItem's data in a conflict-friendly way.
 
 @param key The key of the item to mutate.
 @param mutator The mutator that you provide to modify the data passed in.
 @param flowId A developer specified identifier for this remote request.
 @param completion Completion block that will specify the result of the operation.
 */
- (void)mutateItemWithKey:(nonnull NSString *)key
                  mutator:(nonnull TWSDataMutator)mutator
                   flowId:(NSUInteger)flowId
               completion:(nullable TWSMapItemCompletion)completion;

/** Removes the MapItem with the specified key.
 
 @param key The key of the item to remove.
 @param flowId A developer specified identifier for this remote request.
 @param completion Completion block that will specify the result of the operation.
 */
- (void)removeItemWithKey:(nonnull NSString *)key
                   flowId:(NSUInteger)flowId
               completion:(nullable TWSCompletion)completion;

/** Query the map's items with the requested parameters.
 
 @param mapQueryOptions The options for the map query.
 @param completion Completion block that will specify the result of the operation and a paginator for this page of results.
 */
- (void)queryItemsWithOptions:(nonnull TWSMapQueryOptions *)mapQueryOptions
                   completion:(nonnull TWSMapPaginatorCompletion)completion;

/** Remove the map from the system, deleting it.
 
 @param flowId A developer specified identifier for this remote request.
 @param completion Completion block that will specify the result of the operation.
 */
- (void)removeMapWithFlowId:(NSUInteger)flowId
                 completion:(nullable TWSCompletion)completion;

@end

/** The delegate that will be called with lifecycle updates for the map. */
@protocol TWSMapDelegate<NSObject>
@optional

/** Called when the map referenced is opened.
 
 @param map The map.
 */
- (void)onMapResultOpened:(nonnull TWSMap *)map;

/** Called when a map item is set as a result of a local operation.
 
 @param map The map.
 @param itemKey The key of the item.
 @param flowId A developer specified identifier for this remote request.
 */
- (void)onMap:(nonnull TWSMap *)map resultItemSetWithKey:(nonnull NSString *)itemKey forFlowID:(NSUInteger)flowId;

/** Called when the map item at the specified index is removed as a result of a local operation.
 
 @param map The map.
 @param itemKey The key of the item.
 @param flowId A developer specified identifier for this remote request.
 */
- (void)onMap:(nonnull TWSMap *)map resultItemRemovedWithKey:(nonnull NSString *)itemKey forFlowID:(NSUInteger)flowId;

/** Called when an error occurs as a result of a local operation.
 
 @param map The map.
 @param error The error encounted.
 @param flowId A developer specified identifier for this remote request.
 */
- (void)onMap:(nullable TWSMap *)map resultErrorOccurred:(nonnull TWSError *)error forFlowID:(NSUInteger)flowId;

/** Called when the map is removed as a result of a local operation.
 
 @param map The map.
 @param flowId A developer specified identifier for this remote request.
 */
- (void)onMap:(nonnull TWSMap *)map resultCollectionRemovedForFlowID:(NSUInteger)flowId;

/** Called when a map item is set as a result of a remote operation.
 
 @param map The map.
 @param itemKey The key of the item.
 @param item The item.
 */
- (void)onMap:(nonnull TWSMap *)map remoteItemSetWithKey:(nonnull NSString *)itemKey item:(nonnull TWSMapItem *)item;

/** Called when a map item is removed as a result of a remote operation.
 
 @param map The map.
 @param itemKey The key of the item.
 */
- (void)onMap:(nonnull TWSMap *)map remoteItemRemovedWithKey:(nonnull NSString *)itemKey;

/** Called when the map is removed as a result of a remote operation.
 
 @param map The map.
 */
- (void)onMapRemoteCollectionRemoved:(nonnull TWSMap *)map;

/** Called when an error occurs as a result of a remote operation.
 
 @param map The map.
 @param error The error encounted.
 */
- (void)onMap:(nonnull TWSMap *)map remoteErrorOccurred:(nullable TWSError *)error;
@end
