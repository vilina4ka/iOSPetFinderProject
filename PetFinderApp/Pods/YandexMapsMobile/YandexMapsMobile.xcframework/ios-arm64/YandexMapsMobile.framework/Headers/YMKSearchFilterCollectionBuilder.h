#import <Foundation/Foundation.h>

@class YMKSearchFilterCollection;
@class YMKSearchFilterCollectionBuilder;

/**
 * Builder for filter collection.
 */
@interface YMKSearchFilterCollectionBuilder : NSObject

/**
 * Adds boolean filter with given id to collection.
 *
 * @param filterId filter id to add.
 */
- (void)addBooleanFilterWithFilterId:(nonnull NSString *)filterId;

/**
 * Adds enum filter with given id and values to the collection.
 *
 * @param filterId filter id to add.
 * @param valueIds list of value ids for the enum filter.
 */
- (void)addEnumFilterWithFilterId:(nonnull NSString *)filterId
                         valueIds:(nonnull NSArray<NSString *> *)valueIds;

/**
 * Adds range filter with given id and limits to the collection.
 *
 * @param filterId filter id to add.
 * @param from lower range limit.
 * @param to upper range limit.
 */
- (void)addRangeFilterWithFilterId:(nonnull NSString *)filterId
                              from:(double)from
                                to:(double)to;

/**
 * Adds date filter with given id and limits to the collection. Limits
 * are encoded as strings in YYYYMMDD format.
 *
 * @param filterId filter id to add.
 * @param from lower range limit.
 * @param to upper range limit.
 */
- (void)addDateFilterWithFilterId:(nonnull NSString *)filterId
                             from:(nonnull NSString *)from
                               to:(nonnull NSString *)to;

/**
 * Builds resulting collection.
 * @return collection built from previously given filters.
 */
- (nonnull YMKSearchFilterCollection *)build;

@end

/**
 * Undocumented
 */
@interface YMKSearchFilterCollectionUtils : NSObject

/**
 * Creates new YMKSearchFilterCollectionBuilder.
 * @return builder for YMKSearchFilterCollection.
 */
+ (nonnull YMKSearchFilterCollectionBuilder *)createFilterCollectionBuilder;

@end
