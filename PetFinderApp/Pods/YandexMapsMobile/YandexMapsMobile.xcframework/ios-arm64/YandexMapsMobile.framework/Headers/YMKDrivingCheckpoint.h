#import <YandexMapsMobile/YMKGeometry.h>

/**
 * A checkpoint object.
 */
@interface YMKDrivingCheckpoint : NSObject

/**
 * The position of the checkpoint.
 */
@property (nonatomic, readonly, nonnull) YMKPolylinePosition *position;


+ (nonnull YMKDrivingCheckpoint *)checkpointWithPosition:(nonnull YMKPolylinePosition *)position;


@end
