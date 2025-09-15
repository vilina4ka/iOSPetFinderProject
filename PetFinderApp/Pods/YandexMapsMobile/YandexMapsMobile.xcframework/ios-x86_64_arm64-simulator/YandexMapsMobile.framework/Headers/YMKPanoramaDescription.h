#import <YandexMapsMobile/YMKAttribution.h>
#import <YandexMapsMobile/YMKDirection.h>
#import <YandexMapsMobile/YMKPoint.h>
#import <YandexMapsMobile/YMKSpan.h>

#import <UIKit/UIKit.h>

/**
 * Listener to handle event from user panoramas
 */
@protocol YMKPanoramaUserPanoramaDelegate <NSObject>

/**
 * Called when user presses to the arrow or icon connection. It's a good
 * place to handle panoramaId and call openPanorama...
 *
 * @param panoramaId The clicked connection panoramaId
 */
- (void)onPanoramaChangeIntentWithPanoramaId:(nonnull NSString *)panoramaId;

@end

/**
 * Undocumented
 */
@protocol YMKPanoramaTileImageFactory <NSObject>

/**
 * Called once the tile is within the view frustum. If tile can't be
 * loaded, empty value must be returned.
 *
 * This method will be called on a background thread.
 *
 * @param panoramaId The id of the panorama to get tile for.
 * @param x Tile x coordinate in range
 * [0..tileLevels[tileLevel].width/tileSize.width] x=0,y=0 is the left
 * top corner
 * @param y Tile y coordinate in range
 * [0..ceil(tileLevels[tileLevel].height/tileSize.height)]
 * @param tileLevel Tile level coordinate. One of the given tilelevels
 * level]
 */
- (nullable UIImage *)loadWithPanoramaId:(nonnull NSString *)panoramaId
                                       x:(NSUInteger)x
                                       y:(NSUInteger)y
                               tileLevel:(NSUInteger)tileLevel;

@end

/**
 * Undocumented
 */
@protocol YMKPanoramaIconImageFactory <NSObject>

/**
 * Called once the icon is visible in view frustum If the icon can't be
 * loaded, empty value must be returned. Scale - scale factor. mdpi: 1.0
 * , xhdpi: 2.0, etc. If you have image resources for different pixel
 * densities, just ignore this parameter.
 *
 * This method will be called on a background thread.
 */
- (nullable UIImage *)loadWithIconId:(nonnull NSString *)iconId
                               scale:(double)scale;

@end

/**
 * Undocumented
 */
@protocol YMKPanoramaTileUrlProvider <NSObject>

/**
 * Called once the tile within the view frustum.
 *
 * This method may be called on any thread. Its implementation must be thread-safe.
 *
 * @param panoramaId The id of the panorama to get tile for.
 * @param x Tile x coordinate in range
 * [0..tileLevels[tileLevel].width/tileSize.width] x=0,y=0 is the left
 * top corner
 * @param y Tile y coordinate in range
 * [0..ceil(tileLevels[tileLevel].height/tileSize.height)]
 * @param tileLevel Tile level coordinate. One of the given tilelevels
 * level]
 */
- (nonnull NSString *)formatUrlWithPanoramaId:(nonnull NSString *)panoramaId
                                            x:(NSUInteger)x
                                            y:(NSUInteger)y
                                    tileLevel:(NSUInteger)tileLevel;

@end

/**
 * Undocumented
 */
@protocol YMKPanoramaIconUrlProvider <NSObject>

/**
 * Called once the icon is visible in view frustum Scale - scale factor.
 * mdpi: 1.0 , xhdpi: 2.0 etc.
 *
 * This method may be called on any thread. Its implementation must be thread-safe.
 */
- (nonnull NSString *)formatUrlWithIconId:(nonnull NSString *)iconId
                                    scale:(double)scale;

@end

/**
 * The image size.
 */
@interface YMKPanoramaImageSize : NSObject

/**
 * Undocumented
 */
@property (nonatomic, readonly) NSUInteger width;

/**
 * Undocumented
 */
@property (nonatomic, readonly) NSUInteger height;


+ (nonnull YMKPanoramaImageSize *)imageSizeWithWidth:( NSUInteger)width
                                              height:( NSUInteger)height;


@end

/**
 * The TileLevel struct.
 */
@interface YMKPanoramaTileLevel : NSObject

/**
 * level is passed as a parameter to the TileImageFactory or to the
 * TileUrlProvider. Each panorama description tile level must have
 * unique value.
 */
@property (nonatomic, readonly) NSUInteger level;

/**
 * Source image size. The imageSize width must be multiples of the
 * tileSize width. The imageSize height must be in range
 * [1..imageSize.width/2]
 */
@property (nonatomic, readonly, nonnull) YMKPanoramaImageSize *imageSize;


+ (nonnull YMKPanoramaTileLevel *)tileLevelWithLevel:( NSUInteger)level
                                           imageSize:(nonnull YMKPanoramaImageSize *)imageSize;


@end

/**
 * Position struct
 */
@interface YMKPanoramaPosition : NSObject

/**
 * Longitude and latitude, degrees.
 */
@property (nonatomic, readonly, nonnull) YMKPoint *point;

/**
 * Altitude, meters. Positive is above sea-level
 */
@property (nonatomic, readonly) double altitude;


+ (nonnull YMKPanoramaPosition *)positionWithPoint:(nonnull YMKPoint *)point
                                          altitude:( double)altitude;


@end

/**
 * Text marker struct
 */
@interface YMKPanoramaTextMarker : NSObject

/**
 * Angular position, degrees. (bearing, tilt) (0, 0) - (north, horizon)
 */
@property (nonatomic, readonly, nonnull) YMKDirection *angularPosition;

/**
 * The text displayed in short mode. For example, a house name '14b'
 */
@property (nonatomic, readonly, nonnull) NSString *shortLabel;

/**
 * The text displayed in full mode. For example, street name + house
 * name 'Lesnaya ul. 14b'
 */
@property (nonatomic, readonly, nonnull) NSString *fullLabel;


+ (nonnull YMKPanoramaTextMarker *)textMarkerWithAngularPosition:(nonnull YMKDirection *)angularPosition
                                                      shortLabel:(nonnull NSString *)shortLabel
                                                       fullLabel:(nonnull NSString *)fullLabel;


@end

/**
 * Company marker struct
 */
@interface YMKPanoramaCompanyMarker : NSObject

/**
 * Angular position, degrees. (bearing, tilt) (0, 0) - (north, horizon)
 */
@property (nonatomic, readonly, nonnull) YMKDirection *angularPosition;

/**
 * Displayed label. For example, a company name 'Sweet market'
 */
@property (nonatomic, readonly, nonnull) NSString *label;

/**
 * The company iconId. The iconId is passed as a parameter to the
 * IconImageFactory and IconUrlProvider
 */
@property (nonatomic, readonly, nonnull) NSString *iconId;

/**
 * Permalink is passed as a parameter to the onCompanyTap method.
 */
@property (nonatomic, readonly, nonnull) NSString *permalink;


+ (nonnull YMKPanoramaCompanyMarker *)companyMarkerWithAngularPosition:(nonnull YMKDirection *)angularPosition
                                                                 label:(nonnull NSString *)label
                                                                iconId:(nonnull NSString *)iconId
                                                             permalink:(nonnull NSString *)permalink;


@end

/**
 * Icon marker struct
 */
@interface YMKPanoramaIconMarker : NSObject

/**
 * Angular position, degrees. (bearing, tilt) (0, 0) - (north, horizon)
 */
@property (nonatomic, readonly, nonnull) YMKDirection *angularPosition;

/**
 * The marker iconId. The iconId is passed as a parameter to the
 * IconImageFactory and IconUrlProvider
 */
@property (nonatomic, readonly, nonnull) NSString *iconId;


+ (nonnull YMKPanoramaIconMarker *)iconMarkerWithAngularPosition:(nonnull YMKDirection *)angularPosition
                                                          iconId:(nonnull NSString *)iconId;


@end

/**
 * Undocumented
 */
@interface YMKPanoramaIconConnection : NSObject

/**
 * Angular position, degrees. (bearing, tilt) (0, 0) - (north, horizon)
 */
@property (nonatomic, readonly, nonnull) YMKDirection *angularPosition;

/**
 * The connection iconId. The iconId is passed as a parameter to the
 * IconImageFactory and IconUrlProvider once iconId is visible
 */
@property (nonatomic, readonly, nonnull) NSString *iconId;

/**
 * panoramaId is passed as a parameter to the onPanoramaChangeIntent
 * method.
 */
@property (nonatomic, readonly, nonnull) NSString *panoramaId;


+ (nonnull YMKPanoramaIconConnection *)iconConnectionWithAngularPosition:(nonnull YMKDirection *)angularPosition
                                                                  iconId:(nonnull NSString *)iconId
                                                              panoramaId:(nonnull NSString *)panoramaId;


@end

/**
 * Player arrow styles
 */
typedef NS_ENUM(NSUInteger, YMKPanoramaArrowConnectionStyle) {
    /**
     * connection from street to street
     */
    YMKPanoramaArrowConnectionStyleStreet,
    /**
     * connection from indor to indoor
     */
    YMKPanoramaArrowConnectionStyleIndoor,
    /**
     * connection from street to indoor or from indoor to street
     */
    YMKPanoramaArrowConnectionStyleEntry
};

/**
 * Undocumented
 */
@interface YMKPanoramaArrowConnection : NSObject

/**
 * Angular position, degrees. (bearing, tilt) (0, 0) - (north, horizon)
 */
@property (nonatomic, readonly, nonnull) YMKDirection *angularPosition;

/**
 * label is shown near the arrow
 */
@property (nonatomic, readonly, nonnull) NSString *label;

/**
 * Arrow style.
 */
@property (nonatomic, readonly) YMKPanoramaArrowConnectionStyle arrowStyle;

/**
 * panoramaId is passed as a parameter to the onPanoramaChangeIntent
 * method.
 */
@property (nonatomic, readonly, nonnull) NSString *panoramaId;


+ (nonnull YMKPanoramaArrowConnection *)arrowConnectionWithAngularPosition:(nonnull YMKDirection *)angularPosition
                                                                     label:(nonnull NSString *)label
                                                                arrowStyle:( YMKPanoramaArrowConnectionStyle)arrowStyle
                                                                panoramaId:(nonnull NSString *)panoramaId;


@end

/**
 * Angular bbox. Direction + span will be limited between top and bottom
 * It's recommended to have (right - left) = 360.
 */
@interface YMKPanoramaAngularBoundingBox : NSObject

/**
 * Undocumented
 */
@property (nonatomic, readonly) float left;

/**
 * Undocumented
 */
@property (nonatomic, readonly) float top;

/**
 * Undocumented
 */
@property (nonatomic, readonly) float right;

/**
 * Undocumented
 */
@property (nonatomic, readonly) float bottom;


+ (nonnull YMKPanoramaAngularBoundingBox *)angularBoundingBoxWithLeft:( float)left
                                                                  top:( float)top
                                                                right:( float)right
                                                               bottom:( float)bottom;


@end

/**
 * Undocumented
 */
@interface YMKPanoramaDescription : NSObject

/**
 * panoramaId is passed as a parameter to the TileImageFactory or to the
 * TileUrlProvider
 */
@property (nonatomic, readonly, nonnull) NSString *panoramaId;

/**
 * Geo position.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) YMKPanoramaPosition *position;

/**
 * The angularBBox field sets how the tile tilelevels oriented in space.
 * Direction + span will be limited between top and bottom The
 * recommendation for initializing angular bbox: (right - left) == 360.
 * Non 360 degrees panoramas are not supported yet. (top - bottom) <=
 * 180 The angular aspect ratio must be the same as any tileLevel aspect
 * ratio. (right - left)/(top - bottom) ==
 * tileLevel[i].width/tileLevel[i].height
 */
@property (nonatomic, readonly, nonnull) YMKPanoramaAngularBoundingBox *angularBBox;

/**
 * Any tile level imageSize width must be multiple of the tileSize
 * width. Only 256x256 and 512x512 tiles are supported.
 */
@property (nonatomic, readonly, nonnull) YMKPanoramaImageSize *tileSize;

/**
 * The tileLevels is a set of the TileLevel structs. Tile levels can be
 * added in any order. It's recommended to have at least 2 tile levels:
 * - low quality zoom. For example 512x200 - high quality zoom. For
 * axample 20480x8000
 *
 * It can be useful to have several tile levels for huge images to save
 * network traffic and reduce memory and power consumption. So the final
 * tile levels list may look like that: level, width, height 0, 512, 200
 * 1, 2048, 800 2, 5120, 2000 6, 10240, 4000 9, 20480, 8000
 *
 * Player takes into account the view area size and available tile
 * levels and downloads the most suitable level.
 *
 * The tileLevels[i] aspect ratio must be the same. At first low quality
 * zoom is loaded. Once it's done, the panorama player notifies that the
 * panorama is opened and starts loading high quality zoom tiles.
 */
@property (nonatomic, readonly, nonnull) NSArray<YMKPanoramaTileLevel *> *tileLevels;

/**
 * Add marker icons to the panorama
 */
@property (nonatomic, readonly, nonnull) NSArray<YMKPanoramaIconMarker *> *iconMarkers;

/**
 * Add marker text to the panorama
 */
@property (nonatomic, readonly, nonnull) NSArray<YMKPanoramaTextMarker *> *textMarkers;

/**
 * Add company icons and labels to the panorama
 */
@property (nonatomic, readonly, nonnull) NSArray<YMKPanoramaCompanyMarker *> *companyMarkers;

/**
 * Add icons with interaction
 */
@property (nonatomic, readonly, nonnull) NSArray<YMKPanoramaIconConnection *> *iconConnections;

/**
 * Add standard player arrow connections
 */
@property (nonatomic, readonly, nonnull) NSArray<YMKPanoramaArrowConnection *> *arrowConnections;

/**
 * Suggest where to look at once panorama is opened. It's just a
 * recommendation because it depends on angularBBox and span.
 */
@property (nonatomic, readonly, nonnull) YMKDirection *direction;

/**
 * Suggest view area span. It's just a recommendation because it depends
 * on angularBBox and direction.
 */
@property (nonatomic, readonly, nonnull) YMKSpan *span;

/**
 * Panorama author information.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) YMKAttribution *attribution;


+ (nonnull YMKPanoramaDescription *)panoramaDescriptionWithPanoramaId:(nonnull NSString *)panoramaId
                                                             position:(nullable YMKPanoramaPosition *)position
                                                          angularBBox:(nonnull YMKPanoramaAngularBoundingBox *)angularBBox
                                                             tileSize:(nonnull YMKPanoramaImageSize *)tileSize
                                                           tileLevels:(nonnull NSArray<YMKPanoramaTileLevel *> *)tileLevels
                                                          iconMarkers:(nonnull NSArray<YMKPanoramaIconMarker *> *)iconMarkers
                                                          textMarkers:(nonnull NSArray<YMKPanoramaTextMarker *> *)textMarkers
                                                       companyMarkers:(nonnull NSArray<YMKPanoramaCompanyMarker *> *)companyMarkers
                                                      iconConnections:(nonnull NSArray<YMKPanoramaIconConnection *> *)iconConnections
                                                     arrowConnections:(nonnull NSArray<YMKPanoramaArrowConnection *> *)arrowConnections
                                                            direction:(nonnull YMKDirection *)direction
                                                                 span:(nonnull YMKSpan *)span
                                                          attribution:(nullable YMKAttribution *)attribution;


@end
