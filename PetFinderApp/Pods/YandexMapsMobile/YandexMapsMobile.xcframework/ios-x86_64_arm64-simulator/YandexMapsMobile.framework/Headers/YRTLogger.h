#import <Foundation/Foundation.h>

/**
 * :nodoc:
 */
@interface YRTLogger : NSObject

/**
 * Undocumented
 */
+ (void)errorWithStr:(nonnull NSString *)str;

/**
 * Undocumented
 */
+ (void)warnWithStr:(nonnull NSString *)str;

/**
 * Undocumented
 */
+ (void)infoWithStr:(nonnull NSString *)str;

/**
 * Undocumented
 */
+ (void)debugWithStr:(nonnull NSString *)str;

@end
