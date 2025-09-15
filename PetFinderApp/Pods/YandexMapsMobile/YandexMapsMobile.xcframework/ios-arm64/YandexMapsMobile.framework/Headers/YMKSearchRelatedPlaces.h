#import <YandexMapsMobile/YMKPoint.h>
#import <YandexMapsMobile/YMKSearchWorkingHours.h>

/**
 * Related place information.
 */
@interface YMKSearchPlaceInfo : NSObject

/**
 * Place name.
 */
@property (nonatomic, readonly, nonnull) NSString *name;

/**
 * Place URI.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSString *uri;

/**
 * Url template for place photo.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSString *photoUrlTemplate;

/**
 * Server-generated log identifier.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSString *logId;

/**
 * Place position.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) YMKPoint *point;

/**
 * Place category as a string.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSString *category;

/**
 * Short name for a place.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSString *shortName;

/**
 * Place rating as number in 0 to 10 range.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSNumber *rating;

/**
 * Open hours for a place.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) YMKSearchWorkingHours *workingHours;

/**
 * Formatted address for an organization.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSString *address;

/**
 * Tags
 */
@property (nonatomic, readonly, nonnull) NSArray<NSString *> *tag;


+ (nonnull YMKSearchPlaceInfo *)placeInfoWithName:(nonnull NSString *)name
                                              uri:(nullable NSString *)uri
                                 photoUrlTemplate:(nullable NSString *)photoUrlTemplate
                                            logId:(nullable NSString *)logId
                                            point:(nullable YMKPoint *)point
                                         category:(nullable NSString *)category
                                        shortName:(nullable NSString *)shortName
                                           rating:(nullable NSNumber *)rating
                                     workingHours:(nullable YMKSearchWorkingHours *)workingHours
                                          address:(nullable NSString *)address
                                              tag:(nonnull NSArray<NSString *> *)tag;


@end
