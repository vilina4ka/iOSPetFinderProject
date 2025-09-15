#import <YandexMapsMobile/YMKGeometry.h>

#import <UIKit/UIKit.h>

/**
 * Undocumented
 */
typedef NS_ENUM(NSUInteger, YMKDrivingDirectionSignImage) {
    /**
     * Freeway image
     */
    YMKDrivingDirectionSignImageFreewayImage,
    /**
     * Bridge image
     */
    YMKDrivingDirectionSignImageBridgeImage,
    /**
     * Tunnel image
     */
    YMKDrivingDirectionSignImageTunnelImage,
    /**
     * Ferry image
     */
    YMKDrivingDirectionSignImageFerryImage,
    /**
     * Subway station image
     */
    YMKDrivingDirectionSignImageSubwayStationImage,
    /**
     * Railway station image
     */
    YMKDrivingDirectionSignImageRailwayStationImage,
    /**
     * Airport image
     */
    YMKDrivingDirectionSignImageAirportImage,
    /**
     * Hospital image
     */
    YMKDrivingDirectionSignImageHospitalImage,
    /**
     * Railway crossing image
     */
    YMKDrivingDirectionSignImageRailwayCrossingImage,
    /**
     * Ski slope image
     */
    YMKDrivingDirectionSignImageSkiSlopeImage,
    /**
     * Stadium image
     */
    YMKDrivingDirectionSignImageStadiumImage,
    /**
     * Bridge image for Turkey
     */
    YMKDrivingDirectionSignImageBridgeTrImage,
    /**
     * Subway Station Image for Turkey
     */
    YMKDrivingDirectionSignImageSubwayStationTrImage,
    /**
     * Hospital image as H
     */
    YMKDrivingDirectionSignImageHospitalHImage,
    /**
     * Beach image
     */
    YMKDrivingDirectionSignImageBeachImage,
    /**
     * Burj Khalifa image
     */
    YMKDrivingDirectionSignImageBurjKhalifaImage,
    /**
     * Gas image
     */
    YMKDrivingDirectionSignImageGasImage,
    /**
     * Hotel image
     */
    YMKDrivingDirectionSignImageHotelImage,
    /**
     * Kaaba image
     */
    YMKDrivingDirectionSignImageKaabaImage,
    /**
     * Mall image
     */
    YMKDrivingDirectionSignImageMallImage,
    /**
     * Mosque image
     */
    YMKDrivingDirectionSignImageMosqueImage,
    /**
     * Subway image for UAE
     */
    YMKDrivingDirectionSignImageSubwayUAEImage,
    /**
     * Tram image for UAE
     */
    YMKDrivingDirectionSignImageTramUAEImage,
    /**
     * University image
     */
    YMKDrivingDirectionSignImageUniversityImage
};

/**
 * The direction of the manoeuvre on the direction sign.
 */
typedef NS_ENUM(NSUInteger, YMKDrivingDirectionSignDirection) {
    /**
     * 180 degree turn to the left.
     */
    YMKDrivingDirectionSignDirectionLeft180,
    /**
     * 135 degree turn to the left.
     */
    YMKDrivingDirectionSignDirectionLeft135,
    /**
     * 90 degree turn to the left.
     */
    YMKDrivingDirectionSignDirectionLeft90,
    /**
     * 45 degree turn to the left.
     */
    YMKDrivingDirectionSignDirectionLeft45,
    /**
     * Lane going straight ahead.
     */
    YMKDrivingDirectionSignDirectionStraightAhead,
    /**
     * 45 degree turn to the right.
     */
    YMKDrivingDirectionSignDirectionRight45,
    /**
     * 90 degree turn to the right.
     */
    YMKDrivingDirectionSignDirectionRight90,
    /**
     * 135 degree turn to the right.
     */
    YMKDrivingDirectionSignDirectionRight135,
    /**
     * 180 degree turn to the right.
     */
    YMKDrivingDirectionSignDirectionRight180,
    /**
     * Right turn followed by smooth left turn
     */
    YMKDrivingDirectionSignDirectionLeftFromRight,
    /**
     * Left turn followed by smooth right turn
     */
    YMKDrivingDirectionSignDirectionRightFromLeft,
    /**
     * A shift to the left in the lane.
     */
    YMKDrivingDirectionSignDirectionLeftShift,
    /**
     * A shift to the right in the lane.
     */
    YMKDrivingDirectionSignDirectionRightShift
};

/**
 * Undocumented
 */
@interface YMKDrivingDirectionSignStyle : NSObject

/**
 * Text color in RGB format
 */
@property (nonatomic, readonly, nonnull) UIColor *textColor;

/**
 * Background color in RGB format
 */
@property (nonatomic, readonly, nonnull) UIColor *bgColor;


+ (nonnull YMKDrivingDirectionSignStyle *)directionSignStyleWithTextColor:(nonnull UIColor *)textColor
                                                                  bgColor:(nonnull UIColor *)bgColor;


@end

/**
 * Undocumented
 */
@interface YMKDrivingDirectionSignToponym : NSObject

/**
 * Undocumented
 */
@property (nonatomic, readonly, nonnull) NSString *text;

/**
 * Undocumented
 */
@property (nonatomic, readonly, nonnull) YMKDrivingDirectionSignStyle *style;


+ (nonnull YMKDrivingDirectionSignToponym *)directionSignToponymWithText:(nonnull NSString *)text
                                                                   style:(nonnull YMKDrivingDirectionSignStyle *)style;


@end

/**
 * Undocumented
 */
@interface YMKDrivingDirectionSignRoad : NSObject

/**
 * Undocumented
 */
@property (nonatomic, readonly, nonnull) NSString *name;

/**
 * Undocumented
 */
@property (nonatomic, readonly, nonnull) YMKDrivingDirectionSignStyle *style;


+ (nonnull YMKDrivingDirectionSignRoad *)directionSignRoadWithName:(nonnull NSString *)name
                                                             style:(nonnull YMKDrivingDirectionSignStyle *)style;


@end

/**
 * Undocumented
 */
@interface YMKDrivingDirectionSignExit : NSObject

/**
 * Undocumented
 */
@property (nonatomic, readonly, nonnull) NSString *name;

/**
 * Undocumented
 */
@property (nonatomic, readonly, nonnull) YMKDrivingDirectionSignStyle *style;


+ (nonnull YMKDrivingDirectionSignExit *)directionSignExitWithName:(nonnull NSString *)name
                                                             style:(nonnull YMKDrivingDirectionSignStyle *)style;


@end

/**
 * Undocumented
 */
@interface YMKDrivingDirectionSignIcon : NSObject

/**
 * Undocumented
 */
@property (nonatomic, readonly) YMKDrivingDirectionSignImage image;

/**
 * Undocumented
 */
@property (nonatomic, readonly, nonnull) YMKDrivingDirectionSignStyle *style;


+ (nonnull YMKDrivingDirectionSignIcon *)directionSignIconWithImage:( YMKDrivingDirectionSignImage)image
                                                              style:(nonnull YMKDrivingDirectionSignStyle *)style;


@end

/**
 * Undocumented
 */
@interface YMKDrivingDirectionSignItem : NSObject

@property (nonatomic, readonly, nullable) YMKDrivingDirectionSignToponym *toponym;

@property (nonatomic, readonly, nullable) YMKDrivingDirectionSignRoad *road;

@property (nonatomic, readonly, nullable) YMKDrivingDirectionSignExit *exit;

@property (nonatomic, readonly, nullable) YMKDrivingDirectionSignIcon *icon;

+ (nonnull YMKDrivingDirectionSignItem *)directionSignItemWithToponym:(nonnull YMKDrivingDirectionSignToponym *)toponym;

+ (nonnull YMKDrivingDirectionSignItem *)directionSignItemWithRoad:(nonnull YMKDrivingDirectionSignRoad *)road;

+ (nonnull YMKDrivingDirectionSignItem *)directionSignItemWithExit:(nonnull YMKDrivingDirectionSignExit *)exit;

+ (nonnull YMKDrivingDirectionSignItem *)directionSignItemWithIcon:(nonnull YMKDrivingDirectionSignIcon *)icon;

@end


/**
 * The sign showing named directions.
 */
@interface YMKDrivingDirectionSign : NSObject

/**
 * The position of the sign.
 */
@property (nonatomic, readonly, nonnull) YMKPolylinePosition *position;

/**
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSNumber *direction;

/**
 * Undocumented
 */
@property (nonatomic, readonly, nonnull) NSArray<YMKDrivingDirectionSignItem *> *items;


+ (nonnull YMKDrivingDirectionSign *)directionSignWithPosition:(nonnull YMKPolylinePosition *)position
                                                     direction:(nullable NSNumber *)direction
                                                         items:(nonnull NSArray<YMKDrivingDirectionSignItem *> *)items;


@end
