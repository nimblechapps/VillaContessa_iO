//
//  TWSConstants.h
//  Twilio Sync Client
//
//  Copyright (c) 2017 Twilio, Inc. All rights reserved.
//

#import "TWSResult.h"

@class TWSDocument;
@class TWSList;
@class TWSListItem;
@class TWSListPaginator;
@class TWSMap;
@class TWSMapItem;
@class TWSMapPaginator;

/** Immutable representation of a data item. */
typedef NSDictionary<NSString *, id> TWSData;

/** Mutable representation of a data item. */
typedef NSMutableDictionary<NSString *, id> TWSMutableData;

/** Type for item indexes within Sync. */
typedef long long TWSItemIndex;

/** Client connection state. */
typedef NS_ENUM(NSInteger, TWSClientConnectionState) {
    TWSClientConnectionStateUnknown,        ///< Client connection state is not yet known.
    TWSClientConnectionStateDisconnected,   ///< Client is offline and no connection attempt in process.
    TWSClientConnectionStateConnected,      ///< Client is online and ready.
    TWSClientConnectionStateConnecting,     ///< Client is offline and connection attempt is in process.
    TWSClientConnectionStateDenied,         ///< Client connection is denied because of invalid token.
    TWSClientConnectionStateError           ///< Client connection is in the erroneous state.
};

/** Enumeration indicating the client's logging level. */
typedef NS_ENUM(NSInteger, TWSLogLevel) {
    TWSLogLevelFatal = 0,        ///< Show fatal errors only.
    TWSLogLevelCritical,         ///< Show critical log messages as well as all Fatal log messages.
    TWSLogLevelWarning,          ///< Show warnings as well as all Critical log messages.
    TWSLogLevelInfo,             ///< Show informational messages as well as all Warning log messages.
    TWSLogLevelDebug             ///< Show low-level debugging messages as well as all Info log messages.
};

/** Enumeration specifying the requested fetch order relative to the fromIndex or newest/oldest items. */
typedef NS_ENUM(NSInteger, TWSQueryOrder) {
    TWSQueryOrderAscending,      ///< Fetch items in ascending order from starting point.
    TWSQueryOrderDescending      ///< Fetch items in descending order from starting point.
};

/** Enumeration specifying the requested item order relative to the item's index. */
typedef NS_ENUM(NSInteger, TWSPageSort) {
    TWSPageSortAscending,      ///< Order item results in ascending order.
    TWSPageSortDescending      ///< Order item results in descending order.
};

/** Completion block which will indicate the TWSResult of the operation. */
typedef void (^TWSCompletion)(TWSResult *result);

/** Completion block which will indicate the TWSResult of the operation and a document if successful. */
typedef void (^TWSDocumentCompletion)(TWSResult *result, TWSDocument *document);

/** Completion block which will indicate the TWSResult of the operation and a list if successful. */
typedef void (^TWSListCompletion)(TWSResult *result, TWSList *list);

/** Completion block which will indicate the TWSResult of the operation and a list item index if successful. */
typedef void (^TWSListItemIndexCompletion)(TWSResult *result, TWSItemIndex itemIndex);

/** Completion block which will indicate the TWSResult of the operation and a list item if successful. */
typedef void (^TWSListItemCompletion)(TWSResult *result, TWSListItem *item);

/** Completion block which will indicate the TWSResult of the operation and the list paginator if successful. */
typedef void (^TWSListPaginatorCompletion)(TWSResult *result, TWSListPaginator *paginator);

/** Completion block which will indicate the TWSResult of the operation and a map if successful. */
typedef void (^TWSMapCompletion)(TWSResult *result, TWSMap *map);

/** Completion block which will indicate the TWSResult of the operation and a map item if successful. */
typedef void (^TWSMapItemCompletion)(TWSResult *result, TWSMapItem *item);

/** Completion block which will indicate the TWSResult of the operation and the map paginator if successful. */
typedef void (^TWSMapPaginatorCompletion)(TWSResult *result, TWSMapPaginator *paginator);

/** Completion block which will indicate the TWSResult of the operation and the data if successful. */
typedef void (^TWSDataCompletion)(TWSResult *result, TWSData *newData);

/** Mutator to modify a block of TWSData, may be called multiple times if a conflict is encountered on save.
 The mutator you specify will be called with the current value of the data.  In the event of
 a remote update occurring prior to the successful save of the new data, your mutator may be called multiple times
 before being committed.  You can either return an updated TWSMutableData reference or nil to abort the modification.
  */
typedef TWSMutableData * (^TWSDataMutator)(NSUInteger flowId, TWSMutableData *currentData);

/** The Twilio Sync error domain used as NSError's 'domain'. */
FOUNDATION_EXPORT NSString *const TWSErrorDomain;

/** The errorCode specified when an error client side occurs without another specific error code. */
FOUNDATION_EXPORT NSInteger const TWSErrorGeneric;

/** The userInfo key for the error message, if any. */
FOUNDATION_EXPORT NSString *const TWSErrorMsgKey;
