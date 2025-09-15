#import <YandexMapsMobile/YMKTilesUrlProvider.h>
#import <YandexMapsMobile/YMKZoomRange.h>

/// :nodoc:
@interface YMKTilesDefaultUrlProvider : NSObject<YMKTilesUrlProvider>

- (NSString *)formatUrlWithTileId:(YMKTileId *)tileId
                          version:(YMKVersion *)version
                          features:(NSDictionary *) features;

- (void)setUrlPattern:(NSString *)urlPattern;

- (void)setZoomRanges:(NSArray *)zoomRanges;

@end
