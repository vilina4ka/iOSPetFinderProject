#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


/**
 * This class can be used to associate any custom view with PlacemarkMapObject.
 * Snapshot of provided view is taken in constructor and updated any time snapshot method is called by user.
 */
@interface YRTViewProvider : NSObject {
    BOOL _cacheable;
}

/**
 * True if view provider is cacheable. False otherwise.
 */
@property (nonatomic, readonly) BOOL cacheable;

/**
 * Constructor of YRTViewProvider.
 * Attention: This blocks the UI via executing snapshot function.
 */
- (id)initWithUIView:(UIView*)view cacheable:(BOOL)cacheable;
/**
 * Constructor of YRTViewProvider. Cacheable flag will have YES value by default.
 * Attention: This blocks the UI via executing snapshot function.
 */
- (id)initWithUIView:(UIView*)view;
/**
 * Takes a snapshot of the given view.
 * Attention: This blocks the UI.
 */
- (void)snapshot;

@end

