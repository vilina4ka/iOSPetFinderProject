#import <YandexMapsMobile/YMKAttribution.h>

/**
 * Link structure. Combines actual link with attribution and type info.
 */
@interface YMKSearchLink : NSObject

/**
 * Attribution reference.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSString *aref;

/**
 * Actual link.
 */
@property (nonatomic, readonly, nonnull) YMKAttributionLink *link;

/**
 * Link tag. Possible values (non-exhaustive)
 * 'self/social/attribution/showtimes/booking'.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSString *tag;


+ (nonnull YMKSearchLink *)linkWithAref:(nullable NSString *)aref
                                   link:(nonnull YMKAttributionLink *)link
                                    tag:(nullable NSString *)tag;


@end
