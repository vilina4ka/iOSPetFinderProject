#import <YandexMapsMobile/YMKMasstransitSession.h>
#import <YandexMapsMobile/YMKRequestPoint.h>

@class YMKMasstransitRouteSerializer;
@class YMKRouteOptions;
@class YMKTimeOptions;

/**
 * Provides methods for submitting pedestrian routing requests.
 */
@interface YMKPedestrianRouter : NSObject

/**
 * Submits a request to find a pedestrian route.
 *
 * @param points Route points (See YMKRequestPoint for details).
 * Currently only two points are supported (start and finish)
 * @param timeOptions Desired departure/arrival time settings. Empty
 * YMKTimeOptions for requests that are not time-dependent.
 * @param routeOptions Options for route personalization.
 * @param routeListener Listener to retrieve a list of MasstransitRoute
 * objects.
 */
- (nonnull YMKMasstransitSession *)requestRoutesWithPoints:(nonnull NSArray<YMKRequestPoint *> *)points
                                               timeOptions:(nonnull YMKTimeOptions *)timeOptions
                                              routeOptions:(nonnull YMKRouteOptions *)routeOptions
                                              routeHandler:(nonnull YMKMasstransitSessionRouteHandler)routeHandler;

/**
 * Submits a request to fetch a brief summary of a pedestrian route.
 *
 * @param points Route points (See YMKRequestPoint for details).
 * Currently only two points are supported (start and finish)
 * @param timeOptions Desired departure/arrival time settings. Empty
 * YMKTimeOptions for requests that are not time-dependent.
 * @param routeOptions Options for route personalization.
 * @param summaryListener Listener to retrieve a list of summaries.
 */
- (nonnull YMKMasstransitSummarySession *)requestRoutesSummaryWithPoints:(nonnull NSArray<YMKRequestPoint *> *)points
                                                             timeOptions:(nonnull YMKTimeOptions *)timeOptions
                                                            routeOptions:(nonnull YMKRouteOptions *)routeOptions
                                                          summaryHandler:(nonnull YMKMasstransitSummarySessionSummaryHandler)summaryHandler;

/**
 * Submits a request to fetch a brief summary of the pedestrian routes
 * from one to many points.
 *
 * @param from Starting point (See YMKRequestPoint for details).
 * @param to End points.
 * @param timeOptions Desired departure/arrival time settings. Empty
 * YMKTimeOptions for requests that are not time-dependent.
 * @param routeOptions Options for route personalization.
 * @param summaryListener Listener to retrieve a list of summaries.
 */
- (nonnull YMKMasstransitSummarySession *)requestRoutesSummaryWithFrom:(nonnull YMKRequestPoint *)from
                                                                    to:(nonnull NSArray<YMKRequestPoint *> *)to
                                                           timeOptions:(nonnull YMKTimeOptions *)timeOptions
                                                          routeOptions:(nonnull YMKRouteOptions *)routeOptions
                                                        summaryHandler:(nonnull YMKMasstransitSummarySessionSummaryHandler)summaryHandler;

/**
 * Submits a request to retrieve detailed information on the pedestrian
 * route by URI.
 *
 * @param uri Pedestrian route URI. Begins with
 * "ymapsbm1://route/pedestrian".
 * @param timeOptions Desired departure/arrival time settings. Empty
 * YMKTimeOptions for requests that are not time-dependent.
 * @param routeListener Listener to retrieve a list of MasstransitRoute
 * objects.
 */
- (nonnull YMKMasstransitSession *)resolveUriWithUri:(nonnull NSString *)uri
                                         timeOptions:(nonnull YMKTimeOptions *)timeOptions
                                        routeHandler:(nonnull YMKMasstransitSessionRouteHandler)routeHandler;

/**
 * Route serializer.
 */
- (nonnull YMKMasstransitRouteSerializer *)routeSerializer;

@end
