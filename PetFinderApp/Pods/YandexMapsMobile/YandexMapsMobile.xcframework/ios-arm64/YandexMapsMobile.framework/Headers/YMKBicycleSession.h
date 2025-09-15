#import <Foundation/Foundation.h>

@class YMKBicycleRoute;
@class YMKBicycleSummary;

/**
 * Undocumented
 */
typedef void(^YMKBicycleSessionRouteListener)(
    NSArray<YMKBicycleRoute *> * _Nullable routes,
    NSError * _Nullable error);

/**
 * Handler for an async request for bicycle routes.
 */
@interface YMKBicycleSession : NSObject

/**
 * Tries to cancel the current request for bicycle routes.
 */
- (void)cancel;

/**
 * Retries the request for bicycle routes using the specified callback.
 */
- (void)retryWithRouteListener:(nonnull YMKBicycleSessionRouteListener)routeListener;

@end

/**
 * Undocumented
 */
typedef void(^YMKBicycleSummarySessionSummaryHandler)(
    NSArray<YMKBicycleSummary *> * _Nullable routes,
    NSError * _Nullable error);

/**
 * Handler for an async request for a summary of bicycle routes.
 */
@interface YMKBicycleSummarySession : NSObject

/**
 * Tries to cancel the current request for a summary of mass transit
 * routes.
 */
- (void)cancel;

/**
 * Retries the request for a summary of mass transit routes, using the
 * specified callback.
 */
- (void)retryWithSummaryHandler:(nonnull YMKBicycleSummarySessionSummaryHandler)summaryHandler;

@end
