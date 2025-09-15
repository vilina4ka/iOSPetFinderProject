#import <Foundation/Foundation.h>

/**
 * The panorama field of view.
 */
@interface YMKSpan : NSObject

/**
 * The horizontal view angle.
 */
@property (nonatomic, readonly) double horizontalAngle;

/**
 * The vertical view angle.
 */
@property (nonatomic, readonly) double verticalAngle;


+ (nonnull YMKSpan *)spanWithHorizontalAngle:( double)horizontalAngle
                               verticalAngle:( double)verticalAngle;


@end
