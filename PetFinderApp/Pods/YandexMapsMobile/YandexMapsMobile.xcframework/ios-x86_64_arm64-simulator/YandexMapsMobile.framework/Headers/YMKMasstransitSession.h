#import <Foundation/Foundation.h>

@class YMKMasstransitRoute;
@class YMKMasstransitSummary;

/**
 * Undocumented
 */
typedef void(^YMKMasstransitSessionRouteHandler)(
    NSArray<YMKMasstransitRoute *> * _Nullable routes,
    NSError * _Nullable error);

/**
 * Handler for an async request for mass transit routes.
 */
@interface YMKMasstransitSession : NSObject

/**
 * Tries to cancel the current request for mass transit routes.
 */
- (void)cancel;

/**
 * Retries the request for mass transit routes using the specified
 * callback.
 */
- (void)retryWithRouteHandler:(nonnull YMKMasstransitSessionRouteHandler)routeHandler;

@end

/**
 * Undocumented
 */
typedef void(^YMKMasstransitSummarySessionSummaryHandler)(
    NSArray<YMKMasstransitSummary *> * _Nullable routes,
    NSError * _Nullable error);

/**
 * Handler for an async request for a summary of mass transit routes.
 */
@interface YMKMasstransitSummarySession : NSObject

/**
 * Tries to cancel the current request for a summary of mass transit
 * routes.
 */
- (void)cancel;

/**
 * Retries the request for a summary of mass transit routes, using the
 * specified callback.
 */
- (void)retryWithSummaryHandler:(nonnull YMKMasstransitSummarySessionSummaryHandler)summaryHandler;

@end
