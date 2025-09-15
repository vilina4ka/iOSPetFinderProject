#import <Foundation/Foundation.h>

/**
 * Undocumented
 */
@interface YMKTaxiMoney : NSObject

/**
 * Undocumented
 */
@property (nonatomic, readonly) double value;

/**
 * Undocumented
 */
@property (nonatomic, readonly, nonnull) NSString *text;

/**
 * Undocumented
 */
@property (nonatomic, readonly, nonnull) NSString *currency;


+ (nonnull YMKTaxiMoney *)moneyWithValue:( double)value
                                    text:(nonnull NSString *)text
                                currency:(nonnull NSString *)currency;


@end
