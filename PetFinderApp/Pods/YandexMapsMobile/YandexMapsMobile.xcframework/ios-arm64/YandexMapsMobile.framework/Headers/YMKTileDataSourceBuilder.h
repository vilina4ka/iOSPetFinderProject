#import <YandexMapsMobile/YMKBaseDataSourceBuilder.h>
#import <YandexMapsMobile/YMKProjection.h>
#import <YandexMapsMobile/YMKTileFormat.h>
#import <YandexMapsMobile/YMKTileProvider.h>
#import <YandexMapsMobile/YMKTilesUrlProvider.h>
#import <YandexMapsMobile/YMKZoomRange.h>

@class YMKTileDataSourceBuilder;

/**
 * Undocumented
 */
typedef void(^YMKCreateTileDataSource)(
    YMKTileDataSourceBuilder * _Nonnull builder);

/**
 * Undocumented
 */
@interface YMKBaseTileDataSourceBuilder : YMKBaseDataSourceBuilder

/**
 * The class does not retain the object in the 'urlProvider' parameter.
 * It is your responsibility to maintain a strong reference to
 * the target object while it is attached to a class.
 */
- (void)setTileUrlProviderWithUrlProvider:(nonnull id<YMKTilesUrlProvider>)urlProvider;

/**
 * The class does not retain the object in the 'tileProvider' parameter.
 * It is your responsibility to maintain a strong reference to
 * the target object while it is attached to a class.
 */
- (void)setTileProviderWithTileProvider:(nonnull id<YMKTileProvider>)tileProvider;

/**
 * Undocumented
 */
- (void)setProjectionWithProjection:(nonnull YMKProjection *)projection;

/**
 * Undocumented
 */
- (void)setZoomRangesWithZoomRanges:(nonnull NSArray<YMKZoomRange *> *)zoomRanges;

/**
 * Undocumented
 */
- (void)setTileFormatWithFormat:(YMKTileFormat)format;

@end

/**
 * Undocumented
 */
@interface YMKTileDataSourceBuilder : YMKBaseTileDataSourceBuilder

@end
