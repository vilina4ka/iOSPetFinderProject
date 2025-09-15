#import <YandexMapsMobile/YMKDrivingAction.h>
#import <YandexMapsMobile/YMKDrivingLandmark.h>

/**
 * The identifier of the annotation scheme.
 */
typedef NS_ENUM(NSUInteger, YMKDrivingAnnotationSchemeID) {
    /**
     * Small annotation.
     */
    YMKDrivingAnnotationSchemeIDSmall,
    /**
     * Medium annotation.
     */
    YMKDrivingAnnotationSchemeIDMedium,
    /**
     * Large annotation.
     */
    YMKDrivingAnnotationSchemeIDLarge,
    /**
     * Highway annotation.
     */
    YMKDrivingAnnotationSchemeIDHighway
};

/**
 * The length of the U-turn.
 */
@interface YMKDrivingUturnMetadata : NSObject

/**
 * The length of the turn.
 */
@property (nonatomic, readonly) double length;


+ (nonnull YMKDrivingUturnMetadata *)uturnMetadataWithLength:( double)length;


@end

/**
 * The number of the exit for leaving the roundabout.
 */
@interface YMKDrivingLeaveRoundaboutMetadata : NSObject

/**
 * The exit number.
 */
@property (nonatomic, readonly) NSUInteger exitNumber;


+ (nonnull YMKDrivingLeaveRoundaboutMetadata *)leaveRoundaboutMetadataWithExitNumber:( NSUInteger)exitNumber;


@end

/**
 * Information about an action.
 */
@interface YMKDrivingActionMetadata : NSObject

/**
 * The length of the U-turn.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) YMKDrivingUturnMetadata *uturnMetadata;

/**
 * The number of the exit for leaving the roundabout.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) YMKDrivingLeaveRoundaboutMetadata *leaveRoundaboutMetadada;


+ (nonnull YMKDrivingActionMetadata *)actionMetadataWithUturnMetadata:(nullable YMKDrivingUturnMetadata *)uturnMetadata
                                              leaveRoundaboutMetadada:(nullable YMKDrivingLeaveRoundaboutMetadata *)leaveRoundaboutMetadada;


@end

/**
 * The description of the object.
 */
@interface YMKDrivingToponymPhrase : NSObject

/**
 * The string containing the description.
 */
@property (nonatomic, readonly, nonnull) NSString *text;


+ (nonnull YMKDrivingToponymPhrase *)toponymPhraseWithText:(nonnull NSString *)text;


@end

/**
 * The annotation that is displayed on the map.
 */
@interface YMKDrivingAnnotation : NSObject

/**
 * Driver action.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSNumber *action;

/**
 * The toponym of the location.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSString *toponym;

/**
 * Description text to display.
 */
@property (nonatomic, readonly, nonnull) NSString *descriptionText;

/**
 * Action metadata.
 */
@property (nonatomic, readonly, nonnull) YMKDrivingActionMetadata *actionMetadata;

/**
 * Significant landmarks.
 */
@property (nonatomic, readonly, nonnull) NSArray<NSNumber *> *landmarks;

/**
 * The description of the object.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) YMKDrivingToponymPhrase *toponymPhrase;


+ (nonnull YMKDrivingAnnotation *)annotationWithAction:(nullable NSNumber *)action
                                               toponym:(nullable NSString *)toponym
                                       descriptionText:(nonnull NSString *)descriptionText
                                        actionMetadata:(nonnull YMKDrivingActionMetadata *)actionMetadata
                                             landmarks:(nonnull NSArray<NSNumber *> *)landmarks
                                         toponymPhrase:(nullable YMKDrivingToponymPhrase *)toponymPhrase;


@end
