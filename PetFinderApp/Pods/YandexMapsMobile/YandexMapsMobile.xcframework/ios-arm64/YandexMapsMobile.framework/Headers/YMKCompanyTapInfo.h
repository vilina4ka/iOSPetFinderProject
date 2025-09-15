#import <YandexMapsMobile/YMKScreenTypes.h>

/**
 * Undocumented
 */
@interface YMKCompanyTapInfo : NSObject

/**
 * Permalink of the company which icon or text was tapped. The permalink
 * may be used to show company info page
 */
@property (nonatomic, readonly, nonnull) NSString *permalink;

/**
 * The screen position of the company tapped icon. The screenPoint may
 * be useful in positioning company info page
 */
@property (nonatomic, readonly, nonnull) YMKScreenPoint *screenPoint;


+ (nonnull YMKCompanyTapInfo *)companyTapInfoWithPermalink:(nonnull NSString *)permalink
                                               screenPoint:(nonnull YMKScreenPoint *)screenPoint;


@end
