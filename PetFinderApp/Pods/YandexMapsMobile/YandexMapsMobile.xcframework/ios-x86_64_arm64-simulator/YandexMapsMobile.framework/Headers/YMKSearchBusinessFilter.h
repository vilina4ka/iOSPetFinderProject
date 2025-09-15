#import <YandexMapsMobile/YMKImage.h>
#import <YandexMapsMobile/YMKSearchFeature.h>

@class YMKSearchBusinessFilterBooleanValue;
@class YMKSearchBusinessFilterDateValue;
@class YMKSearchBusinessFilterEnumValue;
@class YMKSearchBusinessFilterRangeValue;
@class YMKSearchBusinessFilterValues;

/**
 * A filter that could be applied to search results.
 *
 * Filters can be either boolean (that is Wi-Fi availability in a cafe)
 * or enumerated (that is cuisine type in a restaurant). Enumerated
 * filters support multiple selected values (OR-combined), to search,
 * for example, for restaurants with Armenian or Georgian cuisine at
 * once.
 *
 * This class is used in two separate ways: server response contains all
 * filters applicable to current search request and client can use some
 * of these filters to get more specific results in the following search
 * requests
 */
@interface YMKSearchBusinessFilter : NSObject

/**
 * Filter id.
 */
@property (nonatomic, readonly, nonnull) NSString *id;

/**
 * Human-readable filter name.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSString *name;

/**
 * The filter should not be used by the client, because filter is either
 * used already (selected:true, disabled:true) or nothing would be found
              * (selected:false, disabled:true).
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSNumber *disabled;

/**
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) YMKImage *iconLight;

/**
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) YMKImage *iconDark;

/**
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) YMKImage *iconAfterLight;

/**
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) YMKImage *iconAfterDark;

/**
 * Only one of multiple available values should be selected.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSNumber *singleSelect;

/**
 * Filter values.
 */
@property (nonatomic, readonly, nonnull) YMKSearchBusinessFilterValues *values;


+ (nonnull YMKSearchBusinessFilter *)businessFilterWithId:(nonnull NSString *)id
                                                     name:(nullable NSString *)name
                                                 disabled:(nullable NSNumber *)disabled
                                                iconLight:(nullable YMKImage *)iconLight
                                                 iconDark:(nullable YMKImage *)iconDark
                                           iconAfterLight:(nullable YMKImage *)iconAfterLight
                                            iconAfterDark:(nullable YMKImage *)iconAfterDark
                                             singleSelect:(nullable NSNumber *)singleSelect
                                                   values:(nonnull YMKSearchBusinessFilterValues *)values;


@end

/**
 * Value for boolean filters.
 */
@interface YMKSearchBusinessFilterBooleanValue : NSObject

/**
 * Filter value. Set in server reponse for selected filters.
 */
@property (nonatomic, readonly) BOOL value;

/**
 * Selected marker. Set in server response for selected filters.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSNumber *selected;


+ (nonnull YMKSearchBusinessFilterBooleanValue *)booleanValueWithValue:( BOOL)value
                                                              selected:(nullable NSNumber *)selected;


@end

/**
 * Value for enum filters.
 */
@interface YMKSearchBusinessFilterEnumValue : NSObject

/**
 * Filter value. Set in server response for selected filters.
 */
@property (nonatomic, readonly, nonnull) YMKSearchFeatureEnumValue *value;

/**
 * Selected marker. Set in server response for selected filters.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSNumber *selected;

/**
 * Same as YMKSearchBusinessFilter::disabled, but for this specific enum
 * value.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSNumber *disabled;


+ (nonnull YMKSearchBusinessFilterEnumValue *)enumValueWithValue:(nonnull YMKSearchFeatureEnumValue *)value
                                                        selected:(nullable NSNumber *)selected
                                                        disabled:(nullable NSNumber *)disabled;


@end

/**
 * Value for range filters.
 */
@interface YMKSearchBusinessFilterRangeValue : NSObject

/**
 * Minimum allowed filter value.
 */
@property (nonatomic, readonly) double from;

/**
 * Maximum allowed filter value.
 */
@property (nonatomic, readonly) double to;


+ (nonnull YMKSearchBusinessFilterRangeValue *)rangeValueWithFrom:( double)from
                                                               to:( double)to;


@end

/**
 * Value for date filters.
 */
@interface YMKSearchBusinessFilterDateValue : NSObject

/**
 * :nodoc:
 * Dummy field to make code generation work.
 */
@property (nonatomic, readonly) NSInteger reserved;


+ (nonnull YMKSearchBusinessFilterDateValue *)dateValueWithReserved:( NSInteger)reserved;


@end

/**
 * Possible filter values.
 */
@interface YMKSearchBusinessFilterValues : NSObject

@property (nonatomic, readonly, nullable) NSArray<YMKSearchBusinessFilterBooleanValue *> *booleans;

@property (nonatomic, readonly, nullable) NSArray<YMKSearchBusinessFilterEnumValue *> *enums;

@property (nonatomic, readonly, nullable) YMKSearchBusinessFilterRangeValue *range;

@property (nonatomic, readonly, nullable) YMKSearchBusinessFilterDateValue *date;

+ (nonnull YMKSearchBusinessFilterValues *)valuesWithBooleans:(nonnull NSArray<YMKSearchBusinessFilterBooleanValue *> *)booleans;

+ (nonnull YMKSearchBusinessFilterValues *)valuesWithEnums:(nonnull NSArray<YMKSearchBusinessFilterEnumValue *> *)enums;

+ (nonnull YMKSearchBusinessFilterValues *)valuesWithRange:(nonnull YMKSearchBusinessFilterRangeValue *)range;

+ (nonnull YMKSearchBusinessFilterValues *)valuesWithDate:(nonnull YMKSearchBusinessFilterDateValue *)date;

@end


/**
 * Collection of filters.
 */
@interface YMKSearchFilterSet : NSObject

/**
 * IDs for filters in the collection.
 */
@property (nonatomic, readonly, nonnull) NSArray<NSString *> *ids;


+ (nonnull YMKSearchFilterSet *)filterSetWithIds:(nonnull NSArray<NSString *> *)ids;


@end
