#import <Foundation/Foundation.h>

/**
 * Undocumented
 */
@interface YMKAdjustedClock : NSObject

/**
 * This method returns the time that has been synchronized with Yandex
 * servers. Use it if you don't trust the time on the local device
 * because the user could have set it incorrectly. If time
 * synchronization has failed or not yet finished, the returned value
 * equals the local device's time.
 * @return POSIX time. For more information, see
 * https://en.wikipedia.org/wiki/Unix_time.
 */
- (nonnull NSDate *)now;

/**
 * Notifies AdjustedClock when the application resumes the foreground
 * state.
 */
- (void)resume;

/**
 * Notifies AdjustedClock when the application pauses and goes to the
 * background.
 */
- (void)pause;

/**
 * Tells if this object is valid or no. Any method called on an invalid
 * object will throw an exception. The object becomes invalid only on UI
 * thread, and only when its implementation depends on objects already
 * destroyed by now. Please refer to general docs about the interface for
 * details on its invalidation.
 */
@property (nonatomic, readonly, getter=isValid) BOOL valid;

@end
