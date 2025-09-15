#import <YandexMapsMobile/YMKGeometry.h>

/**
 * A pedestrian crossing object.
 */
@interface YMKDrivingPedestrianCrossing : NSObject

/**
 * The position of pedestrian crossing.
 */
@property (nonatomic, readonly, nonnull) YMKPolylinePosition *position;


+ (nonnull YMKDrivingPedestrianCrossing *)pedestrianCrossingWithPosition:(nonnull YMKPolylinePosition *)position;


@end
