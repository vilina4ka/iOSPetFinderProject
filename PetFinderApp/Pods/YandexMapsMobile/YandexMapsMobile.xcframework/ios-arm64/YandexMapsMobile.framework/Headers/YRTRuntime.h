#import <Foundation/Foundation.h>

/**
 * :nodoc:
 */
@interface YRTRuntime : NSObject

/**
 * Undocumented
 */
+ (nonnull NSString *)version;

/**
 * Undocumented
 */
+ (void)setPreinitializationOptions:(nonnull NSDictionary<NSString *, NSString *> *)runtimeOptions;

/**
 * only for flutter
 */
+ (NSInteger)onDartVMCreated;

/**
 * Undocumented
 */
+ (void)onDetachedFromEngineWithEngineId:(NSInteger)engineId;

@end
