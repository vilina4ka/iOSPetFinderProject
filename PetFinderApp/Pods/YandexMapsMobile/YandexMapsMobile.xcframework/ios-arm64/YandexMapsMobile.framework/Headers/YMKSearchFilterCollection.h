#import <Foundation/Foundation.h>

@class YMKSearchFilterCollectionDateRange;
@class YMKSearchFilterCollectionNumberRange;

/**
 * Filters for search request. Use builder to setup this class.
 */
@interface YMKSearchFilterCollection : NSObject

/**
 * List of boolean filter ids to be set.
 */
@property (nonatomic, readonly, nonnull) NSArray<NSString *> *booleanFilters;

/**
 * Mapping of enum filter ids to list of enum value ids.
 */
@property (nonatomic, readonly, nonnull) NSDictionary<NSString *, NSArray<NSString *> *> *enumFilters;

/**
 * Mapping of range filter ids to number range.
 */
@property (nonatomic, readonly, nonnull) NSDictionary<NSString *, YMKSearchFilterCollectionNumberRange *> *rangeFilters;

/**
 * Mapping of date filter ids to date range.
 */
@property (nonatomic, readonly, nonnull) NSDictionary<NSString *, YMKSearchFilterCollectionDateRange *> *dateFilters;


+ (nonnull YMKSearchFilterCollection *)filterCollectionWithBooleanFilters:(nonnull NSArray<NSString *> *)booleanFilters
                                                              enumFilters:(nonnull NSDictionary<NSString *, NSArray<NSString *> *> *)enumFilters
                                                             rangeFilters:(nonnull NSDictionary<NSString *, YMKSearchFilterCollectionNumberRange *> *)rangeFilters
                                                              dateFilters:(nonnull NSDictionary<NSString *, YMKSearchFilterCollectionDateRange *> *)dateFilters;


@end

/**
 * Number range. Used for range filter.
 */
@interface YMKSearchFilterCollectionNumberRange : NSObject

/**
 * Lower range limit.
 */
@property (nonatomic, readonly) double from;

/**
 * Upper range limit.
 */
@property (nonatomic, readonly) double to;


+ (nonnull YMKSearchFilterCollectionNumberRange *)numberRangeWithFrom:( double)from
                                                                   to:( double)to;


@end

/**
 * Date range. Dates are encoded as strings in YYYYMMDD format.
 */
@interface YMKSearchFilterCollectionDateRange : NSObject

/**
 * Lower range limit.
 */
@property (nonatomic, readonly, nonnull) NSString *from;

/**
 * Upper range limit.
 */
@property (nonatomic, readonly, nonnull) NSString *to;


+ (nonnull YMKSearchFilterCollectionDateRange *)dateRangeWithFrom:(nonnull NSString *)from
                                                               to:(nonnull NSString *)to;


@end
