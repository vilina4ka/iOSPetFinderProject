#import <Foundation/Foundation.h>

/**
 * Logo padding class.
 */
@interface YMKLogoPadding : NSObject

/**
 * Defines horizontal padding.
 */
@property (nonatomic, readonly) NSUInteger horizontalPadding;

/**
 * Defines vertical padding.
 */
@property (nonatomic, readonly) NSUInteger verticalPadding;


+ (nonnull YMKLogoPadding *)paddingWithHorizontalPadding:( NSUInteger)horizontalPadding
                                         verticalPadding:( NSUInteger)verticalPadding;


@end
