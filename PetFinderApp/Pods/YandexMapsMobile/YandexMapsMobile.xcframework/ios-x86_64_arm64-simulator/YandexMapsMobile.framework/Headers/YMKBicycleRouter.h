#import <YandexMapsMobile/YMKBicycleSession.h>
#import <YandexMapsMobile/YMKRequestPoint.h>

/**
 * Undocumented
 */
typedef NS_ENUM(NSUInteger, YMKBicycleVehicleType) {
    /**
     * Undocumented
     */
    YMKBicycleVehicleTypeBicycle,
    /**
     * Undocumented
     */
    YMKBicycleVehicleTypeScooter,
    /**
     * Undocumented
     */
    YMKBicycleVehicleTypeElectricBike
};

/**
 * Provides methods for submitting bicycle routing requests.
 */
__attribute__((deprecated("use masstransit.BicycleRouterV2 instead")))
@interface YMKBicycleRouter : NSObject

/**
 * Submits a request to find a bicycle route.
 *
 * @param points Route points (See YMKRequestPoint for details).
 * Currently only two points are supported (start and finish).
 * @param routeListener Listener to retrieve a list of Route objects.
 *
 * @attention This feature is not available in the free MapKit version.
 */
- (nonnull YMKBicycleSession *)requestRoutesWithPoints:(nonnull NSArray<YMKRequestPoint *> *)points
                                                  type:(YMKBicycleVehicleType)type
                                         routeListener:(nonnull YMKBicycleSessionRouteListener)routeListener;

/**
 * Submits a request to fetch a brief summary of the bicycle routes.
 *
 * @param points Route points (See YMKRequestPoint for details).
 * Currently only two points are supported (start and finish).
 * @param summaryListener Listener to retrieve a list of Route objects.
 *
 * @attention This feature is not available in the free MapKit version.
 */
- (nonnull YMKBicycleSummarySession *)requestRoutesSummaryWithPoints:(nonnull NSArray<YMKRequestPoint *> *)points
                                                                type:(YMKBicycleVehicleType)type
                                                      summaryHandler:(nonnull YMKBicycleSummarySessionSummaryHandler)summaryHandler;

/**
 * Submits a request to retrieve detailed information on a bicycle route
 * by URI.
 *
 * @param uri The URI of the bicycle route. Starts with
 * "ymapsbm1://route/bicycle".
 * @param routeListener Listener to retrieve a list of Route objects.
 *
 * @attention This feature is not available in the free MapKit version.
 */
- (nonnull YMKBicycleSession *)resolveUriWithUri:(nonnull NSString *)uri
                                   routeListener:(nonnull YMKBicycleSessionRouteListener)routeListener;

@end
