#import <Foundation/Foundation.h>

/**
 * Dot-separated version string. Alphabetical symbols are ignored
 * without errors.
 *
 * Examples of correct versions: "1.2.3", "2.0.0-2", "2014.04.25", "42".
 */
@interface YMKVersion : NSObject

/**
 * Version string.
 */
@property (nonatomic, readonly, nonnull) NSString *str;


+ (nonnull YMKVersion *)versionWithStr:(nonnull NSString *)str;


@end
