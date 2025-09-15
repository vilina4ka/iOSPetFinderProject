#import <Foundation/Foundation.h>

/**
 * Undocumented
 */
typedef NS_ENUM(NSUInteger, YMKPurpose) {
    /**
     * This mode uses less resources and is the default.
     */
    YMKPurposeGeneral,
    /**
     * This mode is used to configure LocationManager for automotive
     * navigation. Frequent location updates are desired even though more
     * resources are used.
     */
    YMKPurposeAutomotiveNavigation,
    /**
     * This mode is used to configure LocationManager for pedestrian
     * navigation. Frequent location updates are desired even though more
     * resources are used.
     */
    YMKPurposePedestrianNavigation,
    /**
     * This mode is used to configure LocationManager for bicycle
     * navigation. Frequent location updates are desired even though more
     * resources are used.
     */
    YMKPurposeBicycleNavigation,
    /**
     * This mode is used to configure LocationManager for scooter
     * navigation. Frequent location updates are desired even though more
     * resources are used.
     */
    YMKPurposeScooterNavigation
};
