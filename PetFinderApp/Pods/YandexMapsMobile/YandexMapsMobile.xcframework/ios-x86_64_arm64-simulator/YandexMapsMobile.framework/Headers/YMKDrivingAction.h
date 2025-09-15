#import <Foundation/Foundation.h>

/**
 * Driver actions.
 */
typedef NS_ENUM(NSUInteger, YMKDrivingAction) {
    /**
     * Unknown action.
     */
    YMKDrivingActionUnknown,
    /**
     * Going straight.
     */
    YMKDrivingActionStraight,
    /**
     * Going slightly to the left.
     */
    YMKDrivingActionSlightLeft,
    /**
     * Going slightly to the right.
     */
    YMKDrivingActionSlightRight,
    /**
     * Going left.
     */
    YMKDrivingActionLeft,
    /**
     * Going right.
     */
    YMKDrivingActionRight,
    /**
     * Turning left.
     */
    YMKDrivingActionHardLeft,
    /**
     * Turning right.
     */
    YMKDrivingActionHardRight,
    /**
     * Choosing a fork to the left.
     */
    YMKDrivingActionForkLeft,
    /**
     * Choosing a fork to the right.
     */
    YMKDrivingActionForkRight,
    /**
     * U-turn to the left.
     */
    YMKDrivingActionUturnLeft,
    /**
     * U-turn to the right.
     */
    YMKDrivingActionUturnRight,
    /**
     * Entering a roundabout.
     */
    YMKDrivingActionEnterRoundabout,
    /**
     * Leaving a roundabout.
     */
    YMKDrivingActionLeaveRoundabout,
    /**
     * Boarding a ferry.
     */
    YMKDrivingActionBoardFerry,
    /**
     * Leaving a ferry.
     */
    YMKDrivingActionLeaveFerry,
    /**
     * Exiting to the left.
     */
    YMKDrivingActionExitLeft,
    /**
     * Exiting to the right.
     */
    YMKDrivingActionExitRight,
    /**
     * Finishing the route.
     */
    YMKDrivingActionFinish,
    /**
     * Passing waypoint
     */
    YMKDrivingActionWaypoint
};
