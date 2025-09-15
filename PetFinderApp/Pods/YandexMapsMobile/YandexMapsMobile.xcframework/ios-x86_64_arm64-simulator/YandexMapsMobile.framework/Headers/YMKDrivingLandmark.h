#import <Foundation/Foundation.h>

/**
 * Information about an upcoming landmark.
 */
typedef NS_ENUM(NSUInteger, YMKDrivingLandmark) {
    /**
     * Unknown landmark.
     */
    YMKDrivingLandmarkUnknown,
    /**
     * Traffic lights.
     */
    YMKDrivingLandmarkAtTrafficLights,
    /**
     * The area before traffic lights.
     */
    YMKDrivingLandmarkBeforeTrafficLights,
    /**
     * The area before a bridge.
     */
    YMKDrivingLandmarkBeforeBridge,
    /**
     * The area before a tunnel.
     */
    YMKDrivingLandmarkBeforeTunnel,
    /**
     * The area after a bridge.
     */
    YMKDrivingLandmarkAfterBridge,
    /**
     * The area after a tunnel.
     */
    YMKDrivingLandmarkAfterTunnel,
    /**
     * The area leading to a bridge.
     */
    YMKDrivingLandmarkToBridge,
    /**
     * The area leading to a tunnel.
     */
    YMKDrivingLandmarkIntoTunnel,
    /**
     * The turn into a courtyard.
     */
    YMKDrivingLandmarkIntoCourtyard,
    /**
     * The area leading to a frontage road.
     */
    YMKDrivingLandmarkToFrontageRoad
};
