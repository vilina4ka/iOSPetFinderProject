#import <YandexMapsMobile/YMKGeometry.h>

/**
 * A traffic light object.
 */
@interface YMKDrivingTrafficLight : NSObject

/**
 * The position of the traffic light.
 */
@property (nonatomic, readonly, nonnull) YMKPolylinePosition *position;


+ (nonnull YMKDrivingTrafficLight *)trafficLightWithPosition:(nonnull YMKPolylinePosition *)position;


@end
