#import <YandexMapsMobile/YMKGeometry.h>

/**
 * The direction of the lane.
 */
typedef NS_ENUM(NSUInteger, YMKDrivingLaneDirection) {
    /**
     * Unknown lane direction.
     */
    YMKDrivingLaneDirectionUnknownDirection,
    /**
     * 180 degree turn to the left.
     */
    YMKDrivingLaneDirectionLeft180,
    /**
     * 135 degree turn to the left.
     */
    YMKDrivingLaneDirectionLeft135,
    /**
     * 90 degree turn to the left.
     */
    YMKDrivingLaneDirectionLeft90,
    /**
     * 45 degree turn to the left.
     */
    YMKDrivingLaneDirectionLeft45,
    /**
     * Lane going straight ahead.
     */
    YMKDrivingLaneDirectionStraightAhead,
    /**
     * 45 degree turn to the right.
     */
    YMKDrivingLaneDirectionRight45,
    /**
     * 90 degree turn to the right.
     */
    YMKDrivingLaneDirectionRight90,
    /**
     * 135 degree turn to the right.
     */
    YMKDrivingLaneDirectionRight135,
    /**
     * 180 degree turn to the right.
     */
    YMKDrivingLaneDirectionRight180,
    /**
     * Undocumented
     */
    YMKDrivingLaneDirectionLeftFromRight,
    /**
     * Undocumented
     */
    YMKDrivingLaneDirectionRightFromLeft,
    /**
     * A shift to the left in the lane.
     */
    YMKDrivingLaneDirectionLeftShift,
    /**
     * A shift to the right in the lane.
     */
    YMKDrivingLaneDirectionRightShift
};

/**
 * The type of lane.
 */
typedef NS_ENUM(NSUInteger, YMKDrivingLaneKind) {
    /**
     * Unknown lane type.
     */
    YMKDrivingLaneKindUnknownKind,
    /**
     * Common use lane.
     */
    YMKDrivingLaneKindPlainLane,
    /**
     * A lane for buses.
     */
    YMKDrivingLaneKindBusLane,
    /**
     * A lane for trams.
     */
    YMKDrivingLaneKindTramLane,
    /**
     * A lane for taxis.
     */
    YMKDrivingLaneKindTaxiLane,
    /**
     * A lane for bikes.
     */
    YMKDrivingLaneKindBikeLane
};

/**
 * The lane object.
 */
@interface YMKDrivingLane : NSObject

/**
 * The type of lane.
 */
@property (nonatomic, readonly) YMKDrivingLaneKind laneKind;

/**
 * Lane direction.
 */
@property (nonatomic, readonly, nonnull) NSArray<NSNumber *> *directions;

/**
 * Highlighted lane direction.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSNumber *highlightedDirection;


+ (nonnull YMKDrivingLane *)laneWithLaneKind:( YMKDrivingLaneKind)laneKind
                                  directions:(nonnull NSArray<NSNumber *> *)directions
                        highlightedDirection:(nullable NSNumber *)highlightedDirection;


@end

/**
 * The sign showing a lane.
 */
@interface YMKDrivingLaneSign : NSObject

/**
 * The position of the sign.
 */
@property (nonatomic, readonly, nonnull) YMKPolylinePosition *position;

/**
 * Determines whether the sign should be annotated.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSNumber *annotated;

/**
 * The lane to display the sign in.
 */
@property (nonatomic, readonly, nonnull) NSArray<YMKDrivingLane *> *lanes;


+ (nonnull YMKDrivingLaneSign *)laneSignWithPosition:(nonnull YMKPolylinePosition *)position
                                           annotated:(nullable NSNumber *)annotated
                                               lanes:(nonnull NSArray<YMKDrivingLane *> *)lanes;


@end
