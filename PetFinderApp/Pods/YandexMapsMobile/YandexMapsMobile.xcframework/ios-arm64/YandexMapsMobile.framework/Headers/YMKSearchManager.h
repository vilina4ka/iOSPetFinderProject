#import <YandexMapsMobile/YMKGeometry.h>
#import <YandexMapsMobile/YMKPoint.h>
#import <YandexMapsMobile/YMKSearchSession.h>

@class YMKSearchOptions;
@class YMKSearchSuggestSession;

/**
 * Search manager type. Describes difference in online/offline search
 * handling.
 */
typedef NS_ENUM(NSUInteger, YMKSearchManagerType) {
    /**
     * Online search manager. Always tries to use online search even if
     * network is not available.
     */
    YMKSearchManagerTypeOnline,
    /**
     * Offline search manager. Always tries to use offline search even if
     * network is available.
     * @attention This feature is not available in the free MapKit version.
     */
    YMKSearchManagerTypeOffline,
    /**
     * Combined search manager. Decision to use online or offline search is
     * based on internal timeout. If server manages to respond within given
     * time, then online search result is returned. Otherwise uses offline
     * search.  Will combine online and offline search result in single
     * session (hence the name). Timeout logic is applied on each resubmit
     * until first response from offline search is returned to the listener.
     * After that timeout is reduced to zero for all following resubmits.
     * @attention This feature is not available in the free MapKit version.
     */
    YMKSearchManagerTypeCombined
};

/**
 * Main interface to start search.
 */
@interface YMKSearchManager : NSObject

/**
 * Search request for searching a user query near given geometry.
 *
 * @param text User query.
 * @param geometry Geometry to search near. Supported types: point,
 * bounding box, polyline and polygon. If the polyline is provided,
 * setSortByDistance(polyline) is assumed on the first request. Polygon
 * is expected to be a search window: 4 points in outer ring (or 5 if
 * the last point is equal to the first) and no inner rings.
 * @param searchOptions Various additional search parameters, see
 * YMKSearchOptions definition for details.
 * @param searchListener Listener to handle search result.
 *
 * @return YMKSearchSession which allows further searches, cancel and
 * retry.
 */
- (nonnull YMKSearchSession *)submitWithText:(nonnull NSString *)text
                                    geometry:(nonnull YMKGeometry *)geometry
                               searchOptions:(nonnull YMKSearchOptions *)searchOptions
                             responseHandler:(nonnull YMKSearchSessionResponseHandler)responseHandler;

/**
 * Search request that is used to search for a user query along the
 * given polyline inside the given window.
 *
 * @param text User query.
 * @param polyline Polyline to search near; {@link
 * search.Session#setSortByDistance(const mapkit.geometry.Geometry)} is
 * assumed on the first request.
 * @param geometry Geometry to search near; supported types: point,
 * bounding box, polyline and polygon. Polygon is expected to be a
 * search window: 4 points in outer ring (or 5 if the last point is
 * equal to first) and no inner rings.
 * @param searchOptions Various additional search parameters, see
 * YMKSearchOptions definition for details.
 * @param searchListener Listener to handle search result.
 *
 * @return YMKSearchSession which allows further searches, cancel and
 * retry. Session should be stored by user or search is automatically
 * cancelled.
 */
- (nonnull YMKSearchSession *)submitWithText:(nonnull NSString *)text
                                    polyline:(nonnull YMKPolyline *)polyline
                                    geometry:(nonnull YMKGeometry *)geometry
                               searchOptions:(nonnull YMKSearchOptions *)searchOptions
                             responseHandler:(nonnull YMKSearchSessionResponseHandler)responseHandler;

/**
 * Reverse search request (to search objects at the given coordinates)
 *
 * @param point Coordinates to search at.
 * @param zoom Current zoom level. Skips objects that are too small for
 * a given zoom level.
 * @param searchOptions Additional search parameters, see
 * YMKSearchOptions definition for details. Currently the only supported
 * options are YMKSearchOptions::origin, YMKSearchOptions::searchTypes
 * and YMKSearchOptions::snippets. Only 'geo' and 'biz' types are
 * supported and not at the same time.
 * @param searchListener Listener to handle search result.
 *
 * @return YMKSearchSession which allows further searches, cancel and
 * retry. Session should be stored by user or search is automatically
 * cancelled.
 */
- (nonnull YMKSearchSession *)submitWithPoint:(nonnull YMKPoint *)point
                                         zoom:(nullable NSNumber *)zoom
                                searchOptions:(nonnull YMKSearchOptions *)searchOptions
                              responseHandler:(nonnull YMKSearchSessionResponseHandler)responseHandler;

/**
 * Search request for URI resolution.
 *
 * @param uri Object uri.
 * @param searchOptions Additional search parameters, see
 * YMKSearchOptions definition for details. Currently the only supported
 * options are YMKSearchOptions::origin and YMKSearchOptions::snippets.
 * @param searchListener Listener to handle search result.
 *
 * @return YMKSearchSession which allows search cancel and retry. Should
 * be stored by user or search is automatically cancelled.
 */
- (nonnull YMKSearchSession *)resolveURIWithUri:(nonnull NSString *)uri
                                  searchOptions:(nonnull YMKSearchOptions *)searchOptions
                                responseHandler:(nonnull YMKSearchSessionResponseHandler)responseHandler;

/**
 * Search request with URI. Allows multiple results in response.
 *
 * @param uri Object uri.
 * @param searchOptions Additional search parameters, see
 * YMKSearchOptions definition for details. Currently the only supported
 * options are YMKSearchOptions::origin, YMKSearchOptions::snippets and.
 * YMKSearchOptions::resultPageSize.
 * @param searchListener Listener to handle search result.
 *
 * @return YMKSearchSession which allows search cancel and retry. Should
 * be stored by user or search is automatically cancelled.
 */
- (nonnull YMKSearchSession *)searchByURIWithUri:(nonnull NSString *)uri
                                   searchOptions:(nonnull YMKSearchOptions *)searchOptions
                                 responseHandler:(nonnull YMKSearchSessionResponseHandler)responseHandler;

/**
 * Creates session for suggest requests.
 */
- (nonnull YMKSearchSuggestSession *)createSuggestSession;

@end
