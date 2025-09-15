#import <Foundation/Foundation.h>

@class YMKDrivingRoute;
@class YMKDrivingSummary;

/**
 * Undocumented
 */
typedef void(^YMKDrivingSessionRouteHandler)(
    NSArray<YMKDrivingRoute *> * _Nullable routes,
    NSError * _Nullable error);

/**
 * Driving session information.
 */
@interface YMKDrivingSession : NSObject

/**
 * Cancels the driving session.
 */
- (void)cancel;

/**
 * Tries to create a driving session again.
 */
- (void)retryWithRouteHandler:(nonnull YMKDrivingSessionRouteHandler)routeHandler;

@end

/**
 * Undocumented
 */
typedef void(^YMKDrivingSummarySessionSummaryHandler)(
    NSArray<YMKDrivingSummary *> * _Nullable summaries,
    NSError * _Nullable error);

/**
 * Driving session summary.
 */
@interface YMKDrivingSummarySession : NSObject

/**
 * Cancels route summary generation.
 */
- (void)cancel;

/**
 * Tries to generate a driving session summary again.
 */
- (void)retryWithSummaryHandler:(nonnull YMKDrivingSummarySessionSummaryHandler)summaryHandler;

@end
