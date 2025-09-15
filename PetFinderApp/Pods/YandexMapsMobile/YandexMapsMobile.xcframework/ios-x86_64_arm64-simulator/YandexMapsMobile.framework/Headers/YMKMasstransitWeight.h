#import <YandexMapsMobile/YMKLocalizedValue.h>

/**
 * Numeric characteristics of a route or a route section.
 */
@interface YMKMasstransitWeight : NSObject

/**
 * Travel time for a route or a route section.
 */
@property (nonatomic, readonly, nonnull) YMKLocalizedValue *time;

/**
 * Distance of the pedestrian part of the route or a route section.
 */
@property (nonatomic, readonly, nonnull) YMKLocalizedValue *walkingDistance;

/**
 * The number of transfers for a route or a route section.
 */
@property (nonatomic, readonly) NSUInteger transfersCount;


+ (nonnull YMKMasstransitWeight *)weightWithTime:(nonnull YMKLocalizedValue *)time
                                 walkingDistance:(nonnull YMKLocalizedValue *)walkingDistance
                                  transfersCount:( NSUInteger)transfersCount;


@end
