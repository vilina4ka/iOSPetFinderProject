#import <YandexMapsMobile/YMKSearchAvailability.h>

/**
 * Describes if an organization is open or closed now.
 */
@interface YMKSearchWorkingHoursState : NSObject

/**
 * Is open right now.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSNumber *isOpenNow;

/**
 * Human-readable localized description of current state.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSString *text;

/**
 * Human-readable short localized description of current state.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSString *shortText;

/**
 * One of the following 3 tags: 'break', 'opening_soon', 'closing_soon'.
 * Additional tag values may be added eventually.
 */
@property (nonatomic, readonly, nonnull) NSArray<NSString *> *tags;


+ (nonnull YMKSearchWorkingHoursState *)workingHoursStateWithIsOpenNow:(nullable NSNumber *)isOpenNow
                                                                  text:(nullable NSString *)text
                                                             shortText:(nullable NSString *)shortText
                                                                  tags:(nonnull NSArray<NSString *> *)tags;


@end

/**
 * Open hours for an organization.
 */
@interface YMKSearchWorkingHours : NSObject

/**
 * Human-readable localized open hours description.
 */
@property (nonatomic, readonly, nonnull) NSString *text;

/**
 * Structured open hours information.
 */
@property (nonatomic, readonly, nonnull) NSArray<YMKSearchAvailability *> *availabilities;

/**
 * Current company working status
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) YMKSearchWorkingHoursState *state;


+ (nonnull YMKSearchWorkingHours *)workingHoursWithText:(nonnull NSString *)text
                                         availabilities:(nonnull NSArray<YMKSearchAvailability *> *)availabilities
                                                  state:(nullable YMKSearchWorkingHoursState *)state;


@end
