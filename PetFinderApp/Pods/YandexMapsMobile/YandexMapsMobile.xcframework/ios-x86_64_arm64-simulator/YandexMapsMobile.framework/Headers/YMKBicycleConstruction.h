#import <Foundation/Foundation.h>

/**
 * Construction types for the segments in the geometry.
 */
typedef NS_ENUM(NSUInteger, YMKBicycleConstructionID) {
    /**
     * Regular bicycle path segment or a segment without any additional
     * information known.
     */
    YMKBicycleConstructionIDUnknown,
    /**
     * Edge connecting the route endpoint to the bicycle route network.
     */
    YMKBicycleConstructionIDBinding,
    /**
     * Stairway with stairs going up along a path.
     */
    YMKBicycleConstructionIDStairsUp,
    /**
     * Stairway with stairs going down along a path.
     */
    YMKBicycleConstructionIDStairsDown,
    /**
     * Stairway with no information whether stairs go up or down along a
     * path.
     */
    YMKBicycleConstructionIDStairsUnknown,
    /**
     * Underground crossing.
     */
    YMKBicycleConstructionIDUnderpass,
    /**
     * Overground crossing.
     */
    YMKBicycleConstructionIDOverpass,
    /**
     * Crossing that is not an underground tunnel or a bridge.
     */
    YMKBicycleConstructionIDCrossing,
    /**
     * Tunnel that is not a crossing.
     */
    YMKBicycleConstructionIDTunnel
};
