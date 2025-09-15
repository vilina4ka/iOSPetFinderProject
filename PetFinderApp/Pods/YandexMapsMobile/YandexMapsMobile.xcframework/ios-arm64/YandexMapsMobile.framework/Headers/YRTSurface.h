#import <UIKit/UIKit.h>

/**
 * Here is android only implementation
 */
@interface YRTSurface : NSObject
/**
 * Anchor shifts the region of the frame that will be rendered on the
 * surface. Anchor coordinates are within [0; 1] bounds. Position of
 * frame’s focusPoint will match specified anchorPoint in the surface:
 * - (0, 0) - left bottom corner of the surface; - (1, 1) - right top
 * corner of the surface; Default value is (0.5, 0.5)
 */
@property (nonatomic) CGPoint anchorPoint;

@end
