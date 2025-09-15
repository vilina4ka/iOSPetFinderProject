#import <YandexMapsMobile/YMKLocalizedValue.h>
#import <YandexMapsMobile/YMKPoint.h>

/**
 * @attention This feature is not available in the free MapKit version.
 */
@interface YMKOfflineCacheRegion : NSObject

/**
 * Region ID.
 */
@property (nonatomic, readonly) NSUInteger id;

/**
 * Name of the region.
 */
@property (nonatomic, readonly, nonnull) NSString *name;

/**
 * Country of the region.
 */
@property (nonatomic, readonly, nonnull) NSString *country;

/**
 * Center point.
 */
@property (nonatomic, readonly, nonnull) YMKPoint *center;

/**
 * Region size
 */
@property (nonatomic, readonly, nonnull) YMKLocalizedValue *size;

/**
 * Returns the region creation time.
 */
@property (nonatomic, readonly, nonnull) NSDate *releaseTime;

/**
 * Region id of the parent region.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSNumber *parentId;


+ (nonnull YMKOfflineCacheRegion *)regionWithId:( NSUInteger)id
                                           name:(nonnull NSString *)name
                                        country:(nonnull NSString *)country
                                         center:(nonnull YMKPoint *)center
                                           size:(nonnull YMKLocalizedValue *)size
                                    releaseTime:(nonnull NSDate *)releaseTime
                                       parentId:(nullable NSNumber *)parentId;


@end
