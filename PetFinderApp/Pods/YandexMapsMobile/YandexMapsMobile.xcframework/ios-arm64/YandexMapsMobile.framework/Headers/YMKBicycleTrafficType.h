#import <Foundation/Foundation.h>

/**
 * TrafficTypeID describes who the road is designed for.
 */
typedef NS_ENUM(NSUInteger, YMKBicycleTrafficTypeID) {
    /**
     * Road that is not one of the following types.
     */
    YMKBicycleTrafficTypeIDOther,
    /**
     * Footpath, designed only for pedestrian travel.
     */
    YMKBicycleTrafficTypeIDPedestrian,
    /**
     * Bikepath, designed only for bicycle travel.
     */
    YMKBicycleTrafficTypeIDBicycle,
    /**
     * Road designed for motorized vehicles that might be dangerous for
     * cyclists.
     */
    YMKBicycleTrafficTypeIDAuto
};
