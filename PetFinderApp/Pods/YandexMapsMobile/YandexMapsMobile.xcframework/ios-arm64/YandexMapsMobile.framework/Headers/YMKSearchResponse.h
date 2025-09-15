#import <YandexMapsMobile/YMKGeoObjectCollection.h>
#import <YandexMapsMobile/YMKSearchMetadata.h>

/**
 * Top level structure for search response.
 */
@interface YMKSearchResponse : NSObject

/**
 * Extended response information.
 */
@property (nonatomic, readonly, nonnull) YMKSearchMetadata *metadata;

/**
 * List of objects (organizations, toponyms) in search response.
 */
@property (nonatomic, readonly, nonnull) YMKGeoObjectCollection *collection;

/**
 * Flag describing if this response was built offline.
 */
@property (nonatomic, readonly) BOOL isOffline;


+ (nonnull YMKSearchResponse *)responseWithMetadata:(nonnull YMKSearchMetadata *)metadata
                                         collection:(nonnull YMKGeoObjectCollection *)collection
                                          isOffline:( BOOL)isOffline;


@end
