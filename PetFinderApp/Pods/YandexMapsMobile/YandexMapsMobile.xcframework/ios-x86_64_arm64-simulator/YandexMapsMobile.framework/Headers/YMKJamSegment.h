#import <Foundation/Foundation.h>

/**
 * The intensity of traffic.
 */
typedef NS_ENUM(NSUInteger, YMKJamType) {
    /**
     * Unknown intensity.
     */
    YMKJamTypeUnknown,
    /**
     * Route is blocked.
     */
    YMKJamTypeBlocked,
    /**
     * Route is free.
     */
    YMKJamTypeFree,
    /**
     * Light traffic on route.
     */
    YMKJamTypeLight,
    /**
     * Heavy traffic on route.
     */
    YMKJamTypeHard,
    /**
     * Very heavy traffic on route.
     */
    YMKJamTypeVeryHard
};

/**
 * A segment of a traffic jam that has specific traffic conditions.
 */
@interface YMKJamSegment : NSObject

/**
 * The type of the traffic jam.
 */
@property (nonatomic, readonly) YMKJamType jamType;

/**
 * The speed at which traffic is moving.
 */
@property (nonatomic, readonly) double speed;


+ (nonnull YMKJamSegment *)jamSegmentWithJamType:( YMKJamType)jamType
                                           speed:( double)speed;


@end
