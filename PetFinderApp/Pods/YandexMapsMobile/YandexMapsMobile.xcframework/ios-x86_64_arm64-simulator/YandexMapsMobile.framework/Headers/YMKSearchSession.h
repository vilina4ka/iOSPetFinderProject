#import <YandexMapsMobile/YMKGeometry.h>

@class YMKSearchBusinessFilter;
@class YMKSearchOptions;
@class YMKSearchResponse;

/**
 * Undocumented
 */
typedef void(^YMKSearchSessionResponseHandler)(
    YMKSearchResponse * _Nullable response,
    NSError * _Nullable error);

/**
 * Interface denoting ongoing search session. Allows search cancellation
 * and retry.  For many request types allows further searches.
 */
@interface YMKSearchSession : NSObject

/**
 * Cancels the current request.
 */
- (void)cancel;

/**
 * Retries the last request. If there is an active request, it is
 * cancelled.
 *
 * @param searchListener Listener to handle search result.
 */
- (void)retryWithResponseHandler:(nonnull YMKSearchSessionResponseHandler)responseHandler;

/**
 * Check the availability of the next result page.
 * @return True if there are more search results and one can call
 * YMKSearchSession::fetchNextPageWithResponseHandler:, false otherwise.
 */
- (BOOL)hasNextPage;

/**
 * Request the next page of search results. Ignored if the current
 * request isn't ready. Will throw if called when {@link
 * search.Session#hasNextPage()} is false.
 *
 * @param searchListener Listener to handle search result.
 */
- (void)fetchNextPageWithResponseHandler:(nonnull YMKSearchSessionResponseHandler)responseHandler;

/**
 * Undocumented
 */
- (void)setFiltersWithFilters:(nonnull NSArray<YMKSearchBusinessFilter *> *)filters __attribute__((deprecated("Use {@link SearchOptions#filters} instead.")));

/**
 * Requests sorting by distance for future resubmits. Supported geometry
 * types: point, polyline.
 *
 * @param origin Origin to sort by distance from.
 */
- (void)setSortByDistanceWithOrigin:(nonnull YMKGeometry *)origin;

/**
 * Resets the sort if it was previously set (for example by
 * YMKSearchSession::setSortByDistanceWithOrigin:) for future resubmits.
 */
- (void)resetSort;

/**
 * Sets the search area for future resubmits. Supported geometry types:
 * bounding box, polyline, polygon. Polygon is expected to be a search
 * window: 4 points in outer ring (or 5 if last point is equal to first)
 * and no inner rings.
 *
 * @param area Search area for future resubmits.
 */
- (void)setSearchAreaWithArea:(nonnull YMKGeometry *)area;

/**
 * Set searchOptions for future resubmits.
 *
 * @param searchOptions Additional search parameters, see
 * YMKSearchOptions. Supported options: YMKSearchOptions::origin,
 * YMKSearchOptions::userPosition.
 */
- (void)setSearchOptionsWithSearchOptions:(nonnull YMKSearchOptions *)searchOptions;

/**
 * Redo the last search with currently set values of search area, search
 * options, filters, sort type and sort origin. Isn't applicable to
 * reverse geosearch and URI resolving. Ignored it the current request
 * is the first one; cancels current request otherwise.
 *
 * @param searchListener Listener to handle search result.
 */
- (void)resubmitWithResponseHandler:(nonnull YMKSearchSessionResponseHandler)responseHandler;

@end
