#import <Foundation/Foundation.h>

/**
 * A value respecting the device locale.
 */
@interface YMKLocalizedValue : NSObject

/**
 * Value in SI units for distance, speed and duration.
 */
@property (nonatomic, readonly) double value;

/**
 * Localized text. For example: "15 ft" or "42 km".
 */
@property (nonatomic, readonly, nonnull) NSString *text;


+ (nonnull YMKLocalizedValue *)localizedValueWithValue:( double)value
                                                  text:(nonnull NSString *)text;


@end
