#import <YandexMapsMobile/YMKBaseMetadata.h>

/**
 * Undocumented
 */
@interface YMKPersonalizedPoiExtraMetadataEntry : NSObject<YMKBaseMetadata>

/**
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSString *key;

/**
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSString *value;


+ (nonnull YMKPersonalizedPoiExtraMetadataEntry *)personalizedPoiExtraMetadataEntryWithKey:(nullable NSString *)key
                                                                                     value:(nullable NSString *)value;


@end

/**
 * Undocumented
 */
@interface YMKPersonalizedPoiExtraMetadata : NSObject<YMKBaseMetadata>

/**
 * Undocumented
 */
@property (nonatomic, readonly, nonnull) NSArray<YMKPersonalizedPoiExtraMetadataEntry *> *data;


+ (nonnull YMKPersonalizedPoiExtraMetadata *)personalizedPoiExtraMetadataWithData:(nonnull NSArray<YMKPersonalizedPoiExtraMetadataEntry *> *)data;


@end
