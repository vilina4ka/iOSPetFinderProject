#import <Foundation/Foundation.h>

/**
 * Phone type
 */
typedef NS_ENUM(NSUInteger, YMKSearchPhoneType) {
    /**
     * Phone.
     */
    YMKSearchPhoneTypePhone,
    /**
     * Fax.
     */
    YMKSearchPhoneTypeFax,
    /**
     * Both phone and fax.
     */
    YMKSearchPhoneTypePhoneFax
};

/**
 * Organization phone.
 */
@interface YMKSearchPhone : NSObject

/**
 * Phone type.
 */
@property (nonatomic, readonly) YMKSearchPhoneType type;

/**
 * Full phone number as human readable string.
 */
@property (nonatomic, readonly, nonnull) NSString *formattedNumber;

/**
 * Some additional info to differentiate multiple phones for single
 * organization.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSString *info;

/**
 * Phone country code.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSString *country;

/**
 * Phone prefix.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSString *prefix;

/**
 * Phone extension.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSString *ext;

/**
 * Phone number.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSString *number;


+ (nonnull YMKSearchPhone *)phoneWithType:( YMKSearchPhoneType)type
                          formattedNumber:(nonnull NSString *)formattedNumber
                                     info:(nullable NSString *)info
                                  country:(nullable NSString *)country
                                   prefix:(nullable NSString *)prefix
                                      ext:(nullable NSString *)ext
                                   number:(nullable NSString *)number;


@end
