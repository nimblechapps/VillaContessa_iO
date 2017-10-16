//
//  TWSMapPaginator.h
//  Twilio Sync Client
//
//  Copyright (c) 2017 Twilio, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TWSConstants.h"

@class TWSMapItem;

/** Paging interface to interact with map item query results.
 */
@interface TWSMapPaginator : NSObject

/** Obtain the list of items contained in this page of results.
 
 @return An array of TWSMapItem objects.
 */
- (nonnull NSArray<TWSMapItem *> *)getItems;

/** Determine if there is a next page of results.
 
 @return BOOL indicating the presence of a next page of results.
 */
- (BOOL)hasNextPage;

/** Determine if there is a previous page of results.
 
 @return BOOL indicating the presence of a previous page of results.
 */
- (BOOL)hasPreviousPage;

/** Request the next page of results for this query, if one exists.
 
 @param completion Completion block that will specify the result of the operation and a paginator for the new page of results.
 */
- (void)requestNextPageWithCompletion:(nonnull TWSMapPaginatorCompletion)completion;

/** Request the previous page of results for this query, if one exists.
 
 @param completion Completion block that will specify the result of the operation and a paginator for the new page of results.
 */
- (void)requestPreviousPageWithCompletion:(nonnull TWSMapPaginatorCompletion)completion;
@end
