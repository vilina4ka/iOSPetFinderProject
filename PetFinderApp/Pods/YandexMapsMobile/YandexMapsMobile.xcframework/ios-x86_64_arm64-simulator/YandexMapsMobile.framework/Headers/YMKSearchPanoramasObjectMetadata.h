#import <YandexMapsMobile/YMKBaseMetadata.h>
#import <YandexMapsMobile/YMKDirection.h>
#import <YandexMapsMobile/YMKPoint.h>
#import <YandexMapsMobile/YMKSpan.h>

/**
 * Panorama info.
 */
@interface YMKSearchPanorama : NSObject

/**
 * Machine readable panorama identifier.
 */
@property (nonatomic, readonly, nonnull) NSString *id;

/**
 * Direction of the panorama center.
 */
@property (nonatomic, readonly, nonnull) YMKDirection *direction;

/**
 * H-Span and V-Span hints for the panorama player.
 */
@property (nonatomic, readonly, nonnull) YMKSpan *span;

/**
 * Panorama point.
 */
@property (nonatomic, readonly, nonnull) YMKPoint *point;


+ (nonnull YMKSearchPanorama *)panoramaWithId:(nonnull NSString *)id
                                    direction:(nonnull YMKDirection *)direction
                                         span:(nonnull YMKSpan *)span
                                        point:(nonnull YMKPoint *)point;


@end

/**
 * Snippet data to get panoramas info.
 */
@interface YMKSearchPanoramasObjectMetadata : NSObject<YMKBaseMetadata>

/**
 * List of panoramas.
 */
@property (nonatomic, readonly, nonnull) NSArray<YMKSearchPanorama *> *panoramas;


+ (nonnull YMKSearchPanoramasObjectMetadata *)panoramasObjectMetadataWithPanoramas:(nonnull NSArray<YMKSearchPanorama *> *)panoramas;


@end
