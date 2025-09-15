#import <YandexMapsMobile/YMKAttribution.h>
#import <YandexMapsMobile/YMKBaseMetadata.h>
#import <YandexMapsMobile/YMKGeometry.h>
#import <YandexMapsMobile/YRTTypeDictionary.h>

/**
 * Geo object. Can be displayed as a placemark, polyline, polygon, and
 * other, depending on the geometry type.
 */
@interface YMKGeoObject : NSObject

/**
 * Object name.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSString *name;

/**
 * The description of the object.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSString *descriptionText;

/**
 * The object's geometry.
 */
@property (nonatomic, readonly, nonnull) NSArray<YMKGeometry *> *geometry;

/**
 * A rectangular box around the object.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) YMKBoundingBox *boundingBox;

/**
 * The attribution of information to a specific author.
 */
@property (nonatomic, readonly, nonnull) NSDictionary<NSString *, YMKAttribution *> *attributionMap;

/**
 * The object's metadata.
 */
@property (nonatomic, readonly, nonnull) YRTTypeDictionary<id<YMKBaseMetadata>> *metadataContainer;

/**
 * The name of the internet resource.
 */
@property (nonatomic, readonly, nonnull) NSArray<NSString *> *aref;


+ (nonnull YMKGeoObject *)geoObjectWithName:(nullable NSString *)name
                            descriptionText:(nullable NSString *)descriptionText
                                   geometry:(nonnull NSArray<YMKGeometry *> *)geometry
                                boundingBox:(nullable YMKBoundingBox *)boundingBox
                             attributionMap:(nonnull NSDictionary<NSString *, YMKAttribution *> *)attributionMap
                          metadataContainer:(nonnull YRTTypeDictionary<id<YMKBaseMetadata>> *)metadataContainer
                                       aref:(nonnull NSArray<NSString *> *)aref;


@end
