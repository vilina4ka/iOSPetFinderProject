#import <Foundation/Foundation.h>

/**
 * The type of the vehicle that is used for the route.
 */
typedef NS_ENUM(NSUInteger, YMKDrivingVehicleType) {
    /**
     * Standard vehicle type.
     */
    YMKDrivingVehicleTypeDefault,
    /**
     * Allowed only for Yandex apps
     */
    YMKDrivingVehicleTypeTaxi,
    /**
     * Undocumented
     */
    YMKDrivingVehicleTypeTruck,
    /**
     * Undocumented
     */
    YMKDrivingVehicleTypeMoto
};
