#import <YandexMapsMobile/YMKAdjustedClock.h>
#import <YandexMapsMobile/YMKBicycleRouter.h>
#import <YandexMapsMobile/YMKBicycleRouterV2.h>
#import <YandexMapsMobile/YMKMasstransitRouter.h>
#import <YandexMapsMobile/YMKPedestrianRouter.h>

@class YMKTransport;

/**
 * Undocumented
 */
@interface YMKTransport : NSObject

/**
 * Creates a manager that builds bicycle routes using the origin and
 * destination points.
 */
- (nonnull YMKBicycleRouter *)createBicycleRouter __attribute__((deprecated("use createBicycleRouterV2 instead")));

/**
 * Creates a manager that builds public transit routes using the origin
 * and destination points.
 */
- (nonnull YMKMasstransitRouter *)createMasstransitRouter;

/**
 * Creates a manager that builds pedestrian routes using the origin and
 * destination points.
 */
- (nonnull YMKPedestrianRouter *)createPedestrianRouter;

/**
 * Creates a manager that builds bicycle routes using the origin and
 * destination points.
 */
- (nonnull YMKBicycleRouterV2 *)createBicycleRouterV2;

/**
 * Creates a manager that builds scooter routes using the origin and
 * destination points.
 */
- (nonnull YMKBicycleRouterV2 *)createScooterRouter;

/**
 * Creates a manager that builds electric bike routes using the origin
 * and destination points.
 */
- (nonnull YMKBicycleRouterV2 *)createElectricBikeRouter;
/**
 * Returns the clock that is constantly synchronized with the server.
 */
@property (nonatomic, readonly, readonly, nonnull) YMKAdjustedClock *adjustedClock;

/**
 * Tells if this object is valid or no. Any method called on an invalid
 * object will throw an exception. The object becomes invalid only on UI
 * thread, and only when its implementation depends on objects already
 * destroyed by now. Please refer to general docs about the interface for
 * details on its invalidation.
 */
@property (nonatomic, readonly, getter=isValid) BOOL valid;

@end

/**
 * Undocumented
 */
@interface YMKTransportFactory : NSObject

+ (nonnull YMKTransport *)instance;

@end
