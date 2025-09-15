#import <Foundation/Foundation.h>

/**
 * Desired departure/arrival time settings. Only one the departureTime
 * and arrivalTime fields should be specified.
 */
@interface YMKTimeOptions : NSObject

/**
 * Desired departure time in UTC for a time-dependent route request. The
 * value is specified in milliseconds. This option cannot be used with
 * arrivalTime.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, copy, nullable) NSDate *departureTime;

/**
 * Desired arrival time in UTC for a time-dependent route request. The
 * value is specified in milliseconds. This option cannot be used with
 * departureTime.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, copy, nullable) NSDate *arrivalTime;

+ (nonnull YMKTimeOptions *)timeOptionsWithDepartureTime:(nullable NSDate *)departureTime
                                             arrivalTime:(nullable NSDate *)arrivalTime;


@end

/**
 * Undocumented
 */
@interface YMKFitnessOptions : NSObject

/**
 * If true, router will try avoid steep (in height meaning) routes.
 */
@property (nonatomic, readonly) BOOL avoidSteep;

/**
 * If true, router will try avoid stairs.
 */
@property (nonatomic, readonly) BOOL avoidStairs;


+ (nonnull YMKFitnessOptions *)fitnessOptionsWithAvoidSteep:( BOOL)avoidSteep
                                                avoidStairs:( BOOL)avoidStairs;


- (nonnull YMKFitnessOptions *)init;

@end

/**
 * Settings for router, which help personalize or optimize routes
 */
@interface YMKRouteOptions : NSObject

/**
 * Undocumented
 */
@property (nonatomic, readonly, nonnull) YMKFitnessOptions *fitnessOptions;


+ (nonnull YMKRouteOptions *)routeOptionsWithFitnessOptions:(nonnull YMKFitnessOptions *)fitnessOptions;


- (nonnull YMKRouteOptions *)init;

@end
