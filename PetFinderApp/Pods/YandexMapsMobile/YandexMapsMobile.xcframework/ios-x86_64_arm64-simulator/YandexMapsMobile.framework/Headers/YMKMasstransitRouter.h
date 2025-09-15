#import <YandexMapsMobile/YMKMasstransitSession.h>
#import <YandexMapsMobile/YMKRequestPoint.h>

@class YMKMasstransitRouteSerializer;
@class YMKRouteOptions;
@class YMKTimeOptions;
@class YMKTransitOptions;

/**
 * Provides methods for submitting mass transit routing requests.
 */
@interface YMKMasstransitRouter : NSObject

/**
 * Submits a request to find mass transit routes.
 *
 * @param points Route points (See YMKRequestPoint for details).
 * Currently only two points are supported (start and finish)
 * @param transitOptions Additional parameters for building routes.
 * @param routeOptions Options for route personalization.
 * @param routeListener Listener to retrieve a list of MasstransitRoute
 * objects.
 */
- (nonnull YMKMasstransitSession *)requestRoutesWithPoints:(nonnull NSArray<YMKRequestPoint *> *)points
                                            transitOptions:(nonnull YMKTransitOptions *)transitOptions
                                              routeOptions:(nonnull YMKRouteOptions *)routeOptions
                                              routeHandler:(nonnull YMKMasstransitSessionRouteHandler)routeHandler;

/**
 * Submits a request to fetch a brief summary of a mass transit route.
 */
- (nonnull YMKMasstransitSummarySession *)requestRoutesSummaryWithPoints:(nonnull NSArray<YMKRequestPoint *> *)points
                                                          transitOptions:(nonnull YMKTransitOptions *)transitOptions
                                                            routeOptions:(nonnull YMKRouteOptions *)routeOptions
                                                          summaryHandler:(nonnull YMKMasstransitSummarySessionSummaryHandler)summaryHandler;

/**
 * Submits a request to retrieve detailed information on a mass transit
 * route by URI.
 *
 * @param uri The URI of the mass transit route. Starts with
 * "ymapsbm1://route/transit".
 * @param timeOptions Desired departure/arrival time settings. Empty
 * YMKTimeOptions for requests that are not time-dependent.
 * @param routeListener Listener to retrieve a list of MasstransitRoute
 * objects.
 */
- (nonnull YMKMasstransitSession *)resolveUriWithUri:(nonnull NSString *)uri
                                         timeOptions:(nonnull YMKTimeOptions *)timeOptions
                                        routeHandler:(nonnull YMKMasstransitSessionRouteHandler)routeHandler;

/**
 * Returns a route serializer instance.
 */
- (nonnull YMKMasstransitRouteSerializer *)routeSerializer;

@end
