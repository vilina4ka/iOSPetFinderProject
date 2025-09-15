#import <YandexMapsMobile/YMKBaseMetadata.h>
#import <YandexMapsMobile/YMKGeoObject.h>
#import <YandexMapsMobile/YMKGeometry.h>
#import <YandexMapsMobile/YMKSearchBusinessResultMetadata.h>
#import <YandexMapsMobile/YMKSearchDisplayType.h>
#import <YandexMapsMobile/YMKSearchSort.h>
#import <YandexMapsMobile/YMKSearchToponymResultMetadata.h>

/**
 * Additional info for search response;
 */
@interface YMKSearchMetadata : NSObject<YMKBaseMetadata>

/**
 * Approximate number of found objects.
 */
@property (nonatomic, readonly) NSInteger found;

/**
 * Display type.
 */
@property (nonatomic, readonly) YMKSearchDisplayType displayType;

/**
 * Bounding box of the response as a whole.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) YMKBoundingBox *boundingBox;

/**
 * Server-chosen sorting.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) YMKSearchSort *sort;

/**
 * Geocoder response to the toponym part of the query.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) YMKGeoObject *toponym;

/**
 * Additional info for the response from toponym search.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) YMKSearchToponymResultMetadata *toponymResultMetadata;

/**
 * Additional info for the response from organization search.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) YMKSearchBusinessResultMetadata *businessResultMetadata;

/**
 * Server-generated request ID.
 */
@property (nonatomic, readonly, nonnull) NSString *reqid;

/**
 * Server-generated request context.
 */
@property (nonatomic, readonly, nonnull) NSString *context;

/**
 * Initial request text.
 */
@property (nonatomic, readonly, nonnull) NSString *requestText;

/**
 * Initial request text with correction of spelling mistakes.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSString *correctedRequestText;

/**
 * Initial request bounding box.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) YMKBoundingBox *requestBoundingBox;


+ (nonnull YMKSearchMetadata *)searchMetadataWithFound:( NSInteger)found
                                           displayType:( YMKSearchDisplayType)displayType
                                           boundingBox:(nullable YMKBoundingBox *)boundingBox
                                                  sort:(nullable YMKSearchSort *)sort
                                               toponym:(nullable YMKGeoObject *)toponym
                                 toponymResultMetadata:(nullable YMKSearchToponymResultMetadata *)toponymResultMetadata
                                businessResultMetadata:(nullable YMKSearchBusinessResultMetadata *)businessResultMetadata
                                                 reqid:(nonnull NSString *)reqid
                                               context:(nonnull NSString *)context
                                           requestText:(nonnull NSString *)requestText
                                  correctedRequestText:(nullable NSString *)correctedRequestText
                                    requestBoundingBox:(nullable YMKBoundingBox *)requestBoundingBox;


@end
