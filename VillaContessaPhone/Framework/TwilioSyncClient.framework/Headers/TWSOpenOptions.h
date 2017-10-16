//
//  TWSOpenOptions.h
//  Twilio Sync Client
//
//  Copyright (c) 2017 Twilio, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Options object specifying the open mode and parameters for a Sync entity. */
@interface TWSOpenOptions : NSObject

/** Create a new entity with the uniqueName if provided, return an error if it exists already.
 If no uniqueName is specified, this operation will always succeed provided sufficient permissions.
 
 @param uniqueName The optional unique name for the new entity or nil if no uniqueName is desired.
 */
+ (nonnull TWSOpenOptions *)createWithUniqueName:(nullable NSString *)uniqueName;

/** Create a new or open an existing new entity with the uniqueName provided.
 This operation will always succeed provided sufficient permissions.
 
 @param uniqueName The non-optional unique name to either retrieve or create if needed.
 */
+ (nullable TWSOpenOptions *)withUniqueName:(nonnull NSString *)uniqueName;

/** Open an existing new entity with the SID or uniqueName provided.
 
 @param sidOrUniqueName The non-optional SID or unique name to retrieve.
 */
+ (nullable TWSOpenOptions *)openWithSidOrUniqueName:(nonnull NSString *)sidOrUniqueName;

/** The uniqueName of the entity for the operation. */
- (nullable NSString *)uniqueName;

/** The SID or uniqueName of the entity for the operation. */
- (nullable NSString *)sidOrUniqueName;

@end
