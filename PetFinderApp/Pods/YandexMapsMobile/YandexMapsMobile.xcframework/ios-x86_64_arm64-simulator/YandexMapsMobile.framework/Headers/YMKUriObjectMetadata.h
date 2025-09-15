#import <YandexMapsMobile/YMKBaseMetadata.h>

/**
 * URI that can be used for requests.
 */
@interface YMKUri : NSObject

/**
 * Gets URI.
 */
@property (nonatomic, readonly, nonnull) NSString *value;


+ (nonnull YMKUri *)uriWithValue:(nonnull NSString *)value;


@end

/**
 * URI metadata.
 */
@interface YMKUriObjectMetadata : NSObject<YMKBaseMetadata>

/**
 * Gets a list of URIs.
 */
@property (nonatomic, readonly, nonnull) NSArray<YMKUri *> *uris;


+ (nonnull YMKUriObjectMetadata *)uriObjectMetadataWithUris:(nonnull NSArray<YMKUri *> *)uris;


@end
