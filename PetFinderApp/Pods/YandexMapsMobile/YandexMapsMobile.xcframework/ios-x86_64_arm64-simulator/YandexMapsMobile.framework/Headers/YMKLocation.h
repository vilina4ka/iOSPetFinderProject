#import <YandexMapsMobile/YMKPoint.h>

/**
 * The geographical position of the object.
 */
@interface YMKLocation : NSObject

/**
 * The geographical position.
 */
@property (nonatomic, readonly, nonnull) YMKPoint *position;

/**
 * Location accuracy in meters.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSNumber *accuracy;

/**
 * The altitude of the location in meters.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSNumber *altitude;

/**
 * The accuracy of the altitude in meters.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSNumber *altitudeAccuracy;

/**
 * The current heading in degrees relative to true north, clockwise.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSNumber *heading;

/**
 * The speed in meters per second.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSNumber *speed;

/**
 * The universal identifier of indoor level.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSString *indoorLevelId;

/**
 * Absolute timestamp, in milliseconds since January 1, 1970.
 */
@property (nonatomic, readonly, nonnull) NSDate *absoluteTimestamp;

/**
 * Relative timestamp, number of milliseconds passed on steady clock.
 * Use for interval calculation.
 */
@property (nonatomic, readonly, nonnull) NSDate *relativeTimestamp;


+ (nonnull YMKLocation *)locationWithPosition:(nonnull YMKPoint *)position
                                     accuracy:(nullable NSNumber *)accuracy
                                     altitude:(nullable NSNumber *)altitude
                             altitudeAccuracy:(nullable NSNumber *)altitudeAccuracy
                                      heading:(nullable NSNumber *)heading
                                        speed:(nullable NSNumber *)speed
                                indoorLevelId:(nullable NSString *)indoorLevelId
                            absoluteTimestamp:(nonnull NSDate *)absoluteTimestamp
                            relativeTimestamp:(nonnull NSDate *)relativeTimestamp;


@end
