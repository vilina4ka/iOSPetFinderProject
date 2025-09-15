#import <YandexMapsMobile/YMKJamSegment.h>
#import <YandexMapsMobile/YMKJamStyle.h>
#import <YandexMapsMobile/YMKPolyline.h>

/**
 * Undocumented
 */
@interface YMKMasstransitDrivingJamsPainter : NSObject

/**
 * @ internal
 *
 * Draw driving "jams" with specified "style"
 */
+ (void)applyJamsStyleWithPolyline:(nonnull YMKPolylineMapObject *)polyline
                              jams:(nonnull NSArray<YMKJamSegment *> *)jams
                             style:(nonnull YMKJamStyle *)style;

@end
