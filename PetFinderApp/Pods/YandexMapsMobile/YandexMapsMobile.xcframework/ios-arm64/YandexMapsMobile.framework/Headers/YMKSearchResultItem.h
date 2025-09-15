#import <YandexMapsMobile/YMKGeoObject.h>
#import <YandexMapsMobile/YMKPoint.h>
#import <YandexMapsMobile/YMKSearchSubtitle.h>

/**
 * Wrapper of the GeoObject in response, which makes it easy to get the
 * certain fields from GeoObject
 */
@interface YMKSearchResultItem : NSObject
/**
 * Id (constructed inside)
 */
@property (nonatomic, readonly, nonnull) NSString *id;
/**
 * Name (from GeoObject)
 */
@property (nonatomic, readonly, nonnull) NSString *name;
/**
 * CategoryClass (optional, first if there are several)
 *
 * Optional property, can be nil.
 */
@property (nonatomic, readonly, nullable) NSString *categoryClass;
/**
 * Wrapped GeoObject itself
 */
@property (nonatomic, readonly, nonnull) YMKGeoObject *geoObject;
/**
 * Point from the GeoObject
 */
@property (nonatomic, readonly, nonnull) YMKPoint *point;

/**
 * Does the GeoObject contain details for subtitle
 */
- (BOOL)hasDetails;

/**
 * Details for the subtitle
 */
- (nonnull NSArray<YMKSearchSubtitleItem *> *)details;

/**
 * Is it a collection GeoObject
 */
- (BOOL)isCollection;

/**
 * Is the organization closed now
 */
- (BOOL)isClosed;

/**
 * Is the GeoObject found in offline search
 */
- (BOOL)isOffline;

@end
