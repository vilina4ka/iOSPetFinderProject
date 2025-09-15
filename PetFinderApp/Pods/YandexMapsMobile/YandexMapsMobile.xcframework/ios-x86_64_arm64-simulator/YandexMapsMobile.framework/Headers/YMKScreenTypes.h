#import <Foundation/Foundation.h>

/**
 * A point on the device screen.
 */
@interface YMKScreenPoint : NSObject

/**
 * The horizontal position of the point in pixels from the left screen
 * border.
 */
@property (nonatomic, readonly) float x;

/**
 * The vertical position of the point in pixels from the top screen
 * border.
 */
@property (nonatomic, readonly) float y;


+ (nonnull YMKScreenPoint *)screenPointWithX:( float)x
                                           y:( float)y;


@end

/**
 * A rectangle on the device screen.
 */
@interface YMKScreenRect : NSObject

/**
 * The position of the top left corner of the rectangle.
 */
@property (nonatomic, readonly, nonnull) YMKScreenPoint *topLeft;

/**
 * The position of the bottom right corner of the rectangle.
 */
@property (nonatomic, readonly, nonnull) YMKScreenPoint *bottomRight;


+ (nonnull YMKScreenRect *)screenRectWithTopLeft:(nonnull YMKScreenPoint *)topLeft
                                     bottomRight:(nonnull YMKScreenPoint *)bottomRight;


@end
