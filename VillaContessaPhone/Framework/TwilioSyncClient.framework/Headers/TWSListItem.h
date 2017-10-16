//
//  TWSListItem.h
//  Twilio Sync Client
//
//  Copyright (c) 2017 Twilio, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TWSConstants.h"

/**
 An item contained within a List.
 */
@interface TWSListItem : NSObject

/** Obtain the index of this list item.
 
 @return TWSItemIndex specifying the index.
 */
- (TWSItemIndex)getIndex;

/** Obtain a snapshot of the list item's current data.
 
 @return NSDictionary containing the data.
 */
- (nonnull TWSData *)getData;

@end
