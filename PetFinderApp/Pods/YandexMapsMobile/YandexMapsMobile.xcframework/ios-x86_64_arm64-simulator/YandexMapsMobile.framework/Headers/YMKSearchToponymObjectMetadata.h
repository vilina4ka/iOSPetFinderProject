#import <YandexMapsMobile/YMKBaseMetadata.h>
#import <YandexMapsMobile/YMKPoint.h>
#import <YandexMapsMobile/YMKSearchAddress.h>
#import <YandexMapsMobile/YMKSearchPrecision.h>

/**
 * Additional data for toponym objects.
 */
@interface YMKSearchToponymObjectMetadata : NSObject<YMKBaseMetadata>

/**
 * Structured toponym address
 */
@property (nonatomic, readonly, nonnull) YMKSearchAddress *address;

/**
 * Toponym precision.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSNumber *precision;

/**
 * Former name for toponym if any.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSString *formerName;

/**
 * Point where balloon for the toponym should be shown. Differs for
 * direct and reverse search modes: Direct mode -- toponym center.
 * Reverse mode -- toponym nearest point to the given coordinates.
 */
@property (nonatomic, readonly, nonnull) YMKPoint *balloonPoint;

/**
 * Persistent toponym id (available for Yandex-owned regions).
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSString *id;


+ (nonnull YMKSearchToponymObjectMetadata *)toponymObjectMetadataWithAddress:(nonnull YMKSearchAddress *)address
                                                                   precision:(nullable NSNumber *)precision
                                                                  formerName:(nullable NSString *)formerName
                                                                balloonPoint:(nonnull YMKPoint *)balloonPoint
                                                                          id:(nullable NSString *)id;


@end
