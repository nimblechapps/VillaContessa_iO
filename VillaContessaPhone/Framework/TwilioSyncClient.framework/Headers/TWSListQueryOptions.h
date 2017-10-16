//
//  TWSListQueryOptions.h
//  Twilio Sync Client
//
//  Copyright (c) 2017 Twilio, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TWSConstants.h"

/**
 Options passed while querying List objects within Sync specifying
 query parameters and result set position and sorting.
 */
@interface TWSListQueryOptions : NSObject

/**
 Specifies the initial position of the query.  Results will be inclusive of the item as this
 position, if specified and if it exists.
 
 @param startPosition The starting position for the query.
 @return This object for optional method chaining.
 */
- (nonnull instancetype)withStartPosition:(TWSItemIndex)startPosition;

/**
 Specifies the ordering (i.e. direction) of the query.  If no starting position is provided, 
 ascending will execute the query from beginning and descending will execute the query from the end.
 
 @param queryOrder The ordering of the query.
 @return This object for optional method chaining.
 */
- (nonnull instancetype)withQueryOrder:(TWSQueryOrder)queryOrder;

/**
 Specifies the maximum size of the page returned by the query. The page may contain less items when
 approaching the end of collection.
 
 @param pageSize The maximum size of the page returned by the query.
 @return This object for optional method chaining.
 */
- (nonnull instancetype)withPageSize:(NSUInteger)pageSize;

/**
 Specifies the sorting of items in each page returned by the query.
 
 @param pageSort The sorting of items in each result page.
 @return This object for optional method chaining.
 */
- (nonnull instancetype)withPageSort:(TWSPageSort)pageSort;

/**
 @return The starting position for the query.
 */
- (TWSItemIndex)startPosition;

/** 
 @return The ordering of the query. 
 */
- (TWSQueryOrder)queryOrder;

/**
 @return The maximum size of the page returned by the query.
 */
- (NSUInteger)pageSize;

/**
 @return The sorting of items in each result page.
 */
- (TWSPageSort)pageSort;

@end
