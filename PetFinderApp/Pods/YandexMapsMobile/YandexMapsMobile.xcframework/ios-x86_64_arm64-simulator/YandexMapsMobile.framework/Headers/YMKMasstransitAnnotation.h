#import <YandexMapsMobile/YMKGeometry.h>

/**
 * Action that can be performed
 */
typedef NS_ENUM(NSUInteger, YMKMasstransitActionID) {
    /**
     * Undocumented
     */
    YMKMasstransitActionIDStraight,
    /**
     * Undocumented
     */
    YMKMasstransitActionIDLeft,
    /**
     * Undocumented
     */
    YMKMasstransitActionIDRight,
    /**
     * Undocumented
     */
    YMKMasstransitActionIDDismount
};

/**
 * Landmark type
 */
typedef NS_ENUM(NSUInteger, YMKMasstransitLandmarkID) {
    /**
     * Undocumented
     */
    YMKMasstransitLandmarkIDCrosswalk,
    /**
     * Undocumented
     */
    YMKMasstransitLandmarkIDStairsToUnderpass,
    /**
     * Undocumented
     */
    YMKMasstransitLandmarkIDStairsToOverpass,
    /**
     * Undocumented
     */
    YMKMasstransitLandmarkIDStairs,
    /**
     * Undocumented
     */
    YMKMasstransitLandmarkIDStairsDown,
    /**
     * Undocumented
     */
    YMKMasstransitLandmarkIDStairsUp
};

/**
 * Undocumented
 */
@interface YMKMasstransitToponym : NSObject

/**
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSString *toponym;

/**
 * Toponym in accusative case with preposition
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSString *accusativeToponym;


+ (nonnull YMKMasstransitToponym *)toponymWithToponym:(nullable NSString *)toponym
                                    accusativeToponym:(nullable NSString *)accusativeToponym;


@end

/**
 * Contains info about actions on part of route. Either `action` or
 * `landmark` should be non-empty.
 */
@interface YMKMasstransitAnnotation : NSObject

/**
 * Position of annotation on part of route
 */
@property (nonatomic, readonly, nonnull) YMKPolylinePosition *position;

/**
 * Action
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSNumber *action;

/**
 * Landmark
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSNumber *landmark;

/**
 * The toponym of the location.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) YMKMasstransitToponym *toponym;


+ (nonnull YMKMasstransitAnnotation *)annotationWithPosition:(nonnull YMKPolylinePosition *)position
                                                      action:(nullable NSNumber *)action
                                                    landmark:(nullable NSNumber *)landmark
                                                     toponym:(nullable YMKMasstransitToponym *)toponym;


@end
