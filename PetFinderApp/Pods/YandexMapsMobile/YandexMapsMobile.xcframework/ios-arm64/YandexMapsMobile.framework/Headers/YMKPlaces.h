#import <YandexMapsMobile/YMKMapWindow.h>
#import <YandexMapsMobile/YMKMrcPhotoPlayer.h>
#import <YandexMapsMobile/YMKMrcPhotoTrackPlayer.h>
#import <YandexMapsMobile/YMKPanoramaLayer.h>
#import <YandexMapsMobile/YMKPanoramaPlayer.h>
#import <YandexMapsMobile/YMKService.h>
#import <YandexMapsMobile/YRTPlatformView_Fwd.h>

#import <Foundation/NSObject.h>

@class YMKPlaces;

/**
 * Undocumented
 */
@interface YMKPlaces : NSObject

/**
 * Creates a service that allows to find a panorama closest to the
 * chosen point.
 */
- (nonnull YMKPanoramaService *)createPanoramaService;

/**
 * Creates a layer representing where panoramas are available.
 */
- (nonnull YMKPanoramaLayer *)createPanoramaLayerWithMapWindow:(nonnull YMKMapWindow *)mapWindow;

/**
 * :nodoc:
 * Creates an internal "window" object with scale factor of the main
 * screen needed to show the panorama viewer.
 *
 * Do not call this method - it is for internal use only. To open the
 * panorama viewer, please use the corresponding panorama "view" object.
 */
- (nonnull YMKPanoramaPlayer *)createPanoramaPlayerWithPlatformView:(nonnull id<YRTPlatformView>)platformView;

/**
 * :nodoc:
 * Creates an internal "window" object with the specified scale factor
 * needed to show the panorama viewer.
 *
 * Do not call this method - it is for internal use only. To open the
 * panorama viewer, please use the corresponding panorama "view" object.
 */
- (nonnull YMKPanoramaPlayer *)createPanoramaPlayerWithPlatformView:(nonnull id<YRTPlatformView>)platformView
                                                        scaleFactor:(float)scaleFactor;

/**
 * :nodoc:
 * Creates an internal "window" object needed to show the mrc photo
 * viewer.
 *
 * Do not call this method - it is for internal use only. To open the
 * viewer, use the corresponding mrc photo "view" object instead.
 */
- (nonnull YMKMrcPhotoPlayer *)createMrcPhotoPlayerWithPlatformView:(nonnull id<YRTPlatformView>)platformView;

/**
 * :nodoc:
 * Creates an internal "window" object needed to show the mrc photo
 * track viewer.
 *
 * Do not call this method - it is for internal use only. To open the
 * viewer, use the corresponding mrc photo "view" object instead.
 */
- (nonnull YMKMrcPhotoTrackPlayer *)createMrcPhotoTrackPlayerWithPlatformView:(nonnull id<YRTPlatformView>)platformView;

/**
 * Tells if this object is valid or no. Any method called on an invalid
 * object will throw an exception. The object becomes invalid only on UI
 * thread, and only when its implementation depends on objects already
 * destroyed by now. Please refer to general docs about the interface for
 * details on its invalidation.
 */
@property (nonatomic, readonly, getter=isValid) BOOL valid;

@end

/**
 * Undocumented
 */
@interface YMKPlacesFactory : NSObject

+ (nonnull YMKPlaces *)instance;

@end
