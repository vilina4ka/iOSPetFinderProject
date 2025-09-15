#import <YandexMapsMobile/YMKGeometry.h>

/**
 * A toll post object.
 */
@interface YMKDrivingTollPost : NSObject

/**
 * Undocumented
 */
@property (nonatomic, readonly, nonnull) YMKPolylinePosition *position;

/**
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSNumber *id;

/**
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSNumber *time_with_traffic;

/**
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSNumber *nonTransactional;


+ (nonnull YMKDrivingTollPost *)tollPostWithPosition:(nonnull YMKPolylinePosition *)position
                                                  id:(nullable NSNumber *)id
                                   time_with_traffic:(nullable NSNumber *)time_with_traffic
                                    nonTransactional:(nullable NSNumber *)nonTransactional;


@end
