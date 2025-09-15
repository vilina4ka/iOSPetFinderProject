#import <Foundation/Foundation.h>

/**
 * Precision for matching house numbers (response vs. request).
 */
typedef NS_ENUM(NSUInteger, YMKSearchPrecision) {
    /**
     * The house number in the response is exactly the same as requested
     * (3/2 vs. 3/2)
     */
    YMKSearchPrecisionExact,
    /**
     * The house number in the response has the same number part as the
     * requested one (5 vs. 5a).
     */
    YMKSearchPrecisionNumber,
    /**
     * The house number and coordinates are restored from the house range.
     * This means that there is no information about this specific house,
     * but there is information about a range of houses to infer house
     * position from.
     */
    YMKSearchPrecisionRange,
    /**
     * The house number in the response is close to the requested one (13
     * vs. 11).
     */
    YMKSearchPrecisionNearby
};
