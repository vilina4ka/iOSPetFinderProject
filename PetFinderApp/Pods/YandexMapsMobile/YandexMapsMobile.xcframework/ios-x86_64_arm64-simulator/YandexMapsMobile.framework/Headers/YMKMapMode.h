#import <Foundation/Foundation.h>

/**
 * Supported map style modes
 */
typedef NS_ENUM(NSUInteger, YMKMapMode) {
    /**
     * Basic map
     */
    YMKMapModeMap,
    /**
     * Public transport map
     */
    YMKMapModeTransit,
    /**
     * Automobile navigation map
     */
    YMKMapModeDriving,
    /**
     * Administrative map
     */
    YMKMapModeAdmin,
    /**
     * Legacy basic map design, can be used to preserve compatibility with
     * app design/legacy map customizaitons
     */
    YMKMapModeLegacyMap,
    /**
     * Upcoming basic map design
     */
    YMKMapModeFutureMap
};
