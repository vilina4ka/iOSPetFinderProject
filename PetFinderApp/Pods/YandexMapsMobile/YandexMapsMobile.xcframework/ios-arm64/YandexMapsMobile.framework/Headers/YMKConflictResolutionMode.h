#import <Foundation/Foundation.h>

/**
 * Determines how feature participates in conflict resolution.
 */
typedef NS_ENUM(NSUInteger, YMKConflictResolutionMode) {
    /**
     * Feature can be hidden (if supported) due to conflict with higher
     * feature but will not conflict with lower features.
     */
    YMKConflictResolutionModeMinor,
    /**
     * Feature can be hidden (if supported) due to conflict with higher
     * feature and can displace lower features.
     */
    YMKConflictResolutionModeEqual,
    /**
     * Feature can NOT be hidden but can displace lower features.
     */
    YMKConflictResolutionModeMajor,
    /**
     * Feature doesn't participate in conflict resolution.
     */
    YMKConflictResolutionModeIgnore
};
