#import <Foundation/Foundation.h>

/**
 * The type of map displayed.
 */
typedef NS_ENUM(NSUInteger, YMKMapType) {
    /**
     * Do not use any of the predefined maps.
     */
    YMKMapTypeNone,
    /**
     * Raster map.
     */
    YMKMapTypeMap,
    /**
     * Allowed only for Yandex apps Default satellite map.
     */
    YMKMapTypeSatellite,
    /**
     * Allowed only for Yandex apps Satellite map with roads, placemarks and
     * labels.
     */
    YMKMapTypeHybrid,
    /**
     * Vector map.
     */
    YMKMapTypeVectorMap
};
