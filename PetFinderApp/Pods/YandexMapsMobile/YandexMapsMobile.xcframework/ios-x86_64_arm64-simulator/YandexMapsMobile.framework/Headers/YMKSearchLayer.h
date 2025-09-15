#import <YandexMapsMobile/YMKAssetsProvider.h>
#import <YandexMapsMobile/YMKGeometry.h>
#import <YandexMapsMobile/YMKIconStyle.h>
#import <YandexMapsMobile/YMKRequestType.h>
#import <YandexMapsMobile/YMKSearchBusinessFilter.h>
#import <YandexMapsMobile/YMKSearchFilterCollection.h>
#import <YandexMapsMobile/YMKSearchManager.h>
#import <YandexMapsMobile/YMKSearchMetadata.h>
#import <YandexMapsMobile/YMKSearchOptions.h>

#import <UIKit/UIKit.h>

@class YMKSearchResultItem;

/**
 * Interface for callbacks on search events.
 */
@protocol YMKSearchLayerResponseHandler <NSObject>

/**
 * Called when the search starts.
 *
 * @param requestType Type of the started request.
 */
- (void)onSearchStartWithRequestType:(YMKSearchLayerRequestType)requestType;

/**
 * Called after a succesful search.
 *
 * @param requestType Type of the finished request.
 */
- (void)onSearchSuccessWithRequestType:(YMKSearchLayerRequestType)requestType;

/**
 * Called on any search error.
 *
 * @param error Error occured.
 * @param requestType Type of the finished request.
 */
- (void)onSearchErrorWithError:(nonnull NSError *)error
                   requestType:(YMKSearchLayerRequestType)requestType;

/**
 * Called when presented results are updated and thus search results
 * list can change.
 */
- (void)onPresentedResultsUpdate;

/**
 * Called before all results are cleared.
 */
- (void)onAllResultsClear;

@end

/**
 * Interface for callbacks on placemark events.
 */
@protocol YMKSearchLayerTapHandler <NSObject>

/**
 * Called when user taps on placemark.
 *
 * @param searchResultItem Corresponding search result.
 */
- (BOOL)onTapWithSearchResultItem:(nonnull YMKSearchResultItem *)searchResultItem;

@end

/**
 * The search layer handles the map search requests and displays the
 * results on the map automatically. It also handles the map movements
 * and resubmits searches when needed.
 */
@interface YMKSearchLayer : NSObject

/**
 * Submit search query with search options.
 *
 * @param query User query
 * @param searchOptions Search options
 */
- (void)submitQueryWithQuery:(nonnull NSString *)query
               searchOptions:(nonnull YMKSearchOptions *)searchOptions;

/**
 * Submit search query with search options near provided geometry.
 *
 * @param query User query.
 * @param geometry Geometry to search near. Supported types: point,
 * bounding box, polyline and polygon. Polygon is expected to be a
 * search window: 4 points in outer ring (or 5 if the last point is
 * equal to the first) and no inner rings.
 * @param searchOptions Search options.
 */
- (void)submitQueryWithQuery:(nonnull NSString *)query
                    geometry:(nonnull YMKGeometry *)geometry
               searchOptions:(nonnull YMKSearchOptions *)searchOptions;

/**
 * Submit search request for URI resolution. Allows multiple objects in
 * response.
 *
 * @param uri Object URI.
 * @param searchOptions Additional search parameters. See
 * YMKSearchOptions definition for details, and 'searchByURI' method in
 * YMKSearchManager for currently supported options.
 */
- (void)searchByUriWithUri:(nonnull NSString *)uri
             searchOptions:(nonnull YMKSearchOptions *)searchOptions;

/**
 * Manual resubmit.
 */
- (void)resubmit;

/**
 * Enable or disable search requests (resubmits and submits) when the
 * map is moved. Requests are enabled by default.
 *
 * @param enable Enable requests if true, disable otherwise.
 */
- (void)enableRequestsOnMapMovesWithEnable:(BOOL)enable;

/**
 * Enable or disable moving the map on primary search response. Map
 * moving is enabled by default.
 *
 * @param enable Enable map moving if true, disable otherwise.
 */
- (void)enableMapMoveOnSearchResponseWithEnable:(BOOL)enable;

/**
 * Check if more results could be loaded.
 */
- (BOOL)hasNextPage;

/**
 * Load the next page of results.
 */
- (void)fetchNextPage;

/**
 * Clear the displayed search results from the map.
 */
- (void)clear;

/**
 * Get the list of search results.
 */
- (nonnull NSArray<YMKSearchResultItem *> *)getSearchResultsList;

/**
 * Get the last search response metadata.
 */
- (nullable YMKSearchMetadata *)searchMetadata;

/**
 * Set the search manager. Do not use this method; it is for internal
 * use only.
 *
 * @param searchManager Search manager
 */
- (void)setSearchManagerWithSearchManager:(nonnull YMKSearchManager *)searchManager;

/**
 * Add the search result listener, which will receive notifications from
 * the search layer.
 *
 * The class does not retain the object in the 'searchResultListener' parameter.
 * It is your responsibility to maintain a strong reference to
 * the target object while it is attached to a class.
 *
 * @param searchResultListener Search result listener to add.
 */
- (void)addSearchResultListenerWithSearchResultListener:(nonnull id<YMKSearchLayerResponseHandler>)searchResultListener;

/**
 * Remove search result listener.
 *
 * @param searchResultListener Search result listener to remove.
 */
- (void)removeSearchResultListenerWithSearchResultListener:(nonnull id<YMKSearchLayerResponseHandler>)searchResultListener;

/**
 * Add a placemark listener, which will receive notifications from the
 * search layer.
 *
 * The class does not retain the object in the 'placemarkListener' parameter.
 * It is your responsibility to maintain a strong reference to
 * the target object while it is attached to a class.
 *
 * @param placemarkListener Placemark listener to add.
 */
- (void)addPlacemarkListenerWithPlacemarkListener:(nonnull id<YMKSearchLayerTapHandler>)placemarkListener;

/**
 * Remove placemark listener
 *
 * @param placemarkListener Placemark listener to remove.
 */
- (void)removePlacemarkListenerWithPlacemarkListener:(nonnull id<YMKSearchLayerTapHandler>)placemarkListener;

/**
 * Set sort order of the results by distance from given geometry.
 */
- (void)setSortByDistanceWithOrigin:(nonnull YMKGeometry *)origin;

/**
 * When sorting by distance from polyline sets position on this
 * polyline. Has the same effect as sorting by distance from the
 * sub-polyline from `position` to the end of the polyline. Throws if no
 * polyline is set or position is out of range.
 *
 * @param position new polyline position value
 */
- (void)setPolylinePositionWithPosition:(nonnull YMKPolylinePosition *)position;

/**
 * Reset the sort if it was previously set.
 */
- (void)resetSort;

/**
 * Set search filters.
 *
 * @param filters Business filters
 */
- (void)setFilterCollectionWithFilters:(nullable YMKSearchFilterCollection *)filters;

/**
 * search.FilterCollection)} instead.
 */
- (void)setFiltersWithFilters:(nonnull NSArray<YMKSearchBusinessFilter *> *)filters __attribute__((deprecated("Use {@link SearchLayer#setFilterCollection(const optional")));

/**
 * Set a custom assets provider, which provides images, sizes and icon
 * styles for placemarks.
 *
 * The class does not retain the object in the 'provider' parameter.
 * It is your responsibility to maintain a strong reference to
 * the target object while it is attached to a class.
 *
 * @param provider Assets provider (must not be null)
 */
- (void)setAssetsProviderWithProvider:(nonnull id<YMKAssetsProvider>)provider;

/**
 * Reset the assets provider to default.
 */
- (void)resetAssetsProvider;

/**
 * Select the placemark by ID.
 *
 * @param geoObjectId Placemark identifier
 */
- (void)selectPlacemarkWithGeoObjectId:(nonnull NSString *)geoObjectId;

/**
 * Selected placemark ID.
 * @return Placemark identifier if any placemark is selected, otherwise
 * none.
 */
- (nullable NSString *)selectedPlacemarkId;

/**
 * Deselect all placemarks.
 */
- (void)deselectPlacemark;

/**
 * Update the icon image for each suitable placemark. If the placemark
 * is not found, the image will be put in a queue and will be applied
 * once when the placemark is created. This is not the normal way to set
 * the image. It is highly advisable to return the right image from
 * AssetsProvider.
 *
 * @param geoObjectId Placemark identifier
 * @param iconType Icon type
 * @param image Icon image
 * @param style Icon style
 */
- (void)forceUpdateIconWithGeoObjectId:(nonnull NSString *)geoObjectId
                              iconType:(YMKPlacemarkIconType)iconType
                                 image:(nonnull UIImage *)image
                                 style:(nonnull YMKIconStyle *)style;

/**
 * Force reloading all visible pins from AssetProvider. Use when there
 * is a reason to update ALL the icons simultaneously (for example icon
 * theme change, day/night mode, and other). This can be a pretty
 * expensive operation, as it wipes all the map objects off of the layer
 * and creates them from scratch. Use only if absolutely necessary.
 */
- (void)forceUpdateMapObjects;

/**
 * If enabled, the search layer will obtain and set advertising icons
 * without asking AssetsProvider.
 *
 * @param enable Enable mode if true, disable otherwise
 */
- (void)obtainAdIconsWithEnable:(BOOL)enable;

/**
 * Apply insets (in pixels) to the screen. If inset is not zero, search
 * in the cut-off area will not be performed.
 *
 * @param top Top inset.
 * @param left Left inset.
 * @param bottom Bottom inset.
 * @param right Right inset.
 */
- (void)setInsetsWithTop:(NSUInteger)top
                    left:(NSUInteger)left
                  bottom:(NSUInteger)bottom
                   right:(NSUInteger)right;
/**
 * Search layer visibility. Visible by default. While the layer is
 * invisible resubmits are not performed on map moves, but all the state
 * changing methods (`submitQuery`, `resubmit`, `deselectPlacemark`, and
 * other) are executed as usual.
 */
@property (nonatomic, getter=isVisible) BOOL visible;

/**
 * Tells if this object is valid or no. Any method called on an invalid
 * object will throw an exception. The object becomes invalid only on UI
 * thread, and only when its implementation depends on objects already
 * destroyed by now. Please refer to general docs about the interface for
 * details on its invalidation.
 */
@property (nonatomic, readonly, getter=isValid) BOOL valid;

@end
