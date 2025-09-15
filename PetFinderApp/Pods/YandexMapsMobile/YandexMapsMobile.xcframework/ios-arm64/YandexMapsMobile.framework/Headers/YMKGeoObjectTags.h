#import <YandexMapsMobile/YMKBaseMetadata.h>

/**
 * Geo object tags.
 */
@interface YMKGeoObjectTags : NSObject<YMKBaseMetadata>

/**
 * Undocumented
 */
@property (nonatomic, readonly, nonnull) NSArray<NSString *> *tags;


+ (nonnull YMKGeoObjectTags *)geoObjectTagsWithTags:(nonnull NSArray<NSString *> *)tags;


@end
