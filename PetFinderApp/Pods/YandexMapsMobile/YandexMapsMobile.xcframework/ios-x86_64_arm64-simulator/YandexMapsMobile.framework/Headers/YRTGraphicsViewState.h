#import <Foundation/Foundation.h>

/**
 * :nodoc:
 */
typedef NS_ENUM(NSUInteger, YRTGraphicsViewType) {
    /**
     * Undocumented
     */
    YRTGraphicsViewTypeOpenGl,
    /**
     * Undocumented
     */
    YRTGraphicsViewTypeVulkan
};

/**
 * :nodoc:
 */
@interface YRTGraphicsViewState : NSObject

/**
 * Undocumented
 */
+ (void)logViewCreateAttemptWithGraphicsView:(YRTGraphicsViewType)graphicsView;

/**
 * Undocumented
 */
+ (BOOL)viewCreateAttemptedWithGraphicsView:(YRTGraphicsViewType)graphicsView;

@end
