#import <Foundation/Foundation.h>

/**
 * Sort type as returned in response.
 */
typedef NS_ENUM(NSUInteger, YMKSearchSortType) {
    /**
     * Results are ordered by rank (or "goodness").
     */
    YMKSearchSortTypeRank,
    /**
     * Results are ordered by distance from some origin.
     */
    YMKSearchSortTypeDistance
};

/**
 * Sort origin types when results are ordered by distance (see
 * YMKSearchSortType).
 */
typedef NS_ENUM(NSUInteger, YMKSearchSortOrigin) {
    /**
     * Sort origin is a user position. User position can be set via {link
     * SearchOptions}.
     */
    YMKSearchSortOriginUser,
    /**
     * Sort origin is a toponym extracted from the user query. For example
     * this type can be set for queries like "cafe near Central Park".
     */
    YMKSearchSortOriginQuery,
    /**
     * Sort origin is directly specified by client. This type can be set for
     * sessions with {link search.Session#setSortByDistance(const
     * mapkit.geometry.Geometry)} called.
     */
    YMKSearchSortOriginRequest
};

/**
 * Describes response sort.
 */
@interface YMKSearchSort : NSObject

/**
 * Sorting type.
 */
@property (nonatomic, readonly) YMKSearchSortType type;

/**
 * Sort origin (if results are ordered by distance).
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSNumber *origin;


+ (nonnull YMKSearchSort *)sortWithType:( YMKSearchSortType)type
                                 origin:(nullable NSNumber *)origin;


@end
