#import <Foundation/Foundation.h>

/**
 * Horizontal logo alignment.
 */
typedef NS_ENUM(NSUInteger, YMKLogoHorizontalAlignment) {
    /**
     * Left alignment.
     */
    YMKLogoHorizontalAlignmentLeft,
    /**
     * Center alignment.
     */
    YMKLogoHorizontalAlignmentCenter,
    /**
     * Right alignment.
     */
    YMKLogoHorizontalAlignmentRight
};

/**
 * Vertical logo alignment.
 */
typedef NS_ENUM(NSUInteger, YMKLogoVerticalAlignment) {
    /**
     * Top alignment.
     */
    YMKLogoVerticalAlignmentTop,
    /**
     * Bottom alignment.
     */
    YMKLogoVerticalAlignmentBottom
};

/**
 * Logo alignment class.
 */
@interface YMKLogoAlignment : NSObject

/**
 * Defines horizontal alignment.
 */
@property (nonatomic, readonly) YMKLogoHorizontalAlignment horizontalAlignment;

/**
 * Defines vertical alignment.
 */
@property (nonatomic, readonly) YMKLogoVerticalAlignment verticalAlignment;


+ (nonnull YMKLogoAlignment *)alignmentWithHorizontalAlignment:( YMKLogoHorizontalAlignment)horizontalAlignment
                                             verticalAlignment:( YMKLogoVerticalAlignment)verticalAlignment;


@end
