#import <YandexMapsMobile/YMKGeometry.h>

/**
 * :nodoc:
 */
@interface YMKMrcPhotoTrackPlayer : NSObject

/**
 * Opens photo at a given position on the track. Call to this method
 * stops playback if it is running.
 *
 * @param position Position on track polyline.
 */
- (void)openPhotoAtWithPosition:(nonnull YMKPolylinePosition *)position;

/**
 * Closes the opened photo, track and stops all player actions.
 */
- (void)reset;

/**
 * shows transition arrows and allows switching photos.
 */
- (void)enableMove;

/**
 * Hides transition arrows and disallows switching photos.
 */
- (void)disableMove;

/**
 * Start photos playback along a current route starting from currently
 * open photo or from the beginning of a photo track.
 */
- (void)play;

/**
 * Stop photos playback
 */
- (void)stop;
/**
 * Current photo ID. Set to null when a track is reset or at reset.
 *
 * Optional property, can be nil.
 */
@property (nonatomic, readonly, nullable) NSString *photoId;
/**
 * Currently opened photo position on a photo track polyline. Set to
 * null when a track is reset or at reset.
 *
 * Optional property, can be nil.
 */
@property (nonatomic, readonly, nullable) YMKPolylinePosition *position;
/**
 * Is playback running at the moment.
 */
@property (nonatomic, readonly, getter=isIsPlaying) BOOL isPlaying;

/**
 * Tells if this object is valid or no. Any method called on an invalid
 * object will throw an exception. The object becomes invalid only on UI
 * thread, and only when its implementation depends on objects already
 * destroyed by now. Please refer to general docs about the interface for
 * details on its invalidation.
 */
@property (nonatomic, readonly, getter=isValid) BOOL valid;

@end
