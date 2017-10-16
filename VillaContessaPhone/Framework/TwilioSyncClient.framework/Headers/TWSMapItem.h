//
//  TWSMapItem.h
//  Twilio Sync Client
//
//  Copyright (c) 2017 Twilio, Inc. All rights reserved.
//

#import "TWSConstants.h"

/**
 An item contained within a map.
 */
@interface TWSMapItem : NSObject

/** Obtain the key of this map item.
 
 @return NSString specifying the key.
 */
- (nonnull NSString *)getKey;

/** Obtain a snapshot of the map item's current data.
 
 @return NSDictionary containing the data.
 */
- (nonnull TWSData *)getData;

@end
