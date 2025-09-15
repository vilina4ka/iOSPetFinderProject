#import <YandexMapsMobile/YMKGeometry.h>

/**
 * Undocumented
 */
typedef NS_ENUM(NSUInteger, YMKDrivingRailwayCrossingType) {
    /**
     * Undocumented
     */
    YMKDrivingRailwayCrossingTypeUnknown,
    /**
     * Undocumented
     */
    YMKDrivingRailwayCrossingTypeRegular
};

/**
 * A railway crossing object.
 */
@interface YMKDrivingRailwayCrossing : NSObject

/**
 * Undocumented
 */
@property (nonatomic, readonly) YMKDrivingRailwayCrossingType type;

/**
 * The position of railway crossing.
 */
@property (nonatomic, readonly, nonnull) YMKPolylinePosition *position;


+ (nonnull YMKDrivingRailwayCrossing *)railwayCrossingWithType:( YMKDrivingRailwayCrossingType)type
                                                      position:(nonnull YMKPolylinePosition *)position;


@end
