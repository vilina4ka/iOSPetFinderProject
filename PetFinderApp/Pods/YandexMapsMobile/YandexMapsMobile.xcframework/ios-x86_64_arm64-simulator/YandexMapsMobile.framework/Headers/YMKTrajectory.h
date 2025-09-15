#import <YandexMapsMobile/YMKBaseMetadata.h>

/**
 * This struct is here to automatically generate protobuf parsing
 * functions It is not to be used in platform code
 */
@interface YMKTrajectorySegmentMetadata : NSObject<YMKBaseMetadata>

/**
 * Undocumented
 */
@property (nonatomic, readonly) long long time;

/**
 * Undocumented
 */
@property (nonatomic, readonly) NSUInteger duration;


+ (nonnull YMKTrajectorySegmentMetadata *)trajectorySegmentMetadataWithTime:( long long)time
                                                                   duration:( NSUInteger)duration;


@end
