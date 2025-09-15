#import <YandexMapsMobile/YMKBaseMetadata.h>

/**
 * Geo object metadata which is needed to select object.
 */
@interface YMKGeoObjectSelectionMetadata : NSObject<YMKBaseMetadata>

/**
 * Object ID.
 */
@property (nonatomic, readonly, nonnull) NSString *objectId;

/**
 * Data source name.
 */
@property (nonatomic, readonly, nonnull) NSString *dataSourceName;

/**
 * Layer ID.
 */
@property (nonatomic, readonly, nonnull) NSString *layerId;

/**
 * Group ID.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSNumber *groupId;


+ (nonnull YMKGeoObjectSelectionMetadata *)geoObjectSelectionMetadataWithObjectId:(nonnull NSString *)objectId
                                                                   dataSourceName:(nonnull NSString *)dataSourceName
                                                                          layerId:(nonnull NSString *)layerId
                                                                          groupId:(nullable NSNumber *)groupId;


@end
