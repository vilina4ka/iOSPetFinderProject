#import <YandexMapsMobile/YMKBaseMetadata.h>

@class YMKMasstransitLineStyle;
@class YMKMasstransitTransportContourStyle;

/**
 * Transport types
 */
typedef NS_ENUM(NSUInteger, YMKMasstransitTransportType) {
    /**
     * Undocumented
     */
    YMKMasstransitTransportTypeUnknown,
    /**
     * Undocumented
     */
    YMKMasstransitTransportTypeBus,
    /**
     * Undocumented
     */
    YMKMasstransitTransportTypeMinibus,
    /**
     * Undocumented
     */
    YMKMasstransitTransportTypeRailway,
    /**
     * Undocumented
     */
    YMKMasstransitTransportTypeSuburban,
    /**
     * Undocumented
     */
    YMKMasstransitTransportTypeTram,
    /**
     * Undocumented
     */
    YMKMasstransitTransportTypeTrolleybus,
    /**
     * Undocumented
     */
    YMKMasstransitTransportTypeUnderground,
    /**
     * Undocumented
     */
    YMKMasstransitTransportTypeWater
};

/**
 * Undocumented
 */
typedef NS_ENUM(NSUInteger, YMKMasstransitThreadCategory) {
    /**
     * Primary thread
     */
    YMKMasstransitThreadCategoryPrimary,
    /**
     * Secondary thread
     */
    YMKMasstransitThreadCategorySecondary,
    /**
     * Temporary thread
     */
    YMKMasstransitThreadCategoryTemporary,
    /**
     * Thread going to depot
     */
    YMKMasstransitThreadCategoryToDepot
};

/**
 * Describes various features a stop can have.
 */
@interface YMKMasstransitStopFeatureMask : NSObject

/**
 * The stop is cooled at hot weather conditions.
 */
@property (nonatomic, readonly) BOOL cooled;

/**
 * The stop is heated at cold weather conditions.
 */
@property (nonatomic, readonly) BOOL heated;


+ (nonnull YMKMasstransitStopFeatureMask *)stopFeatureMaskWithCooled:( BOOL)cooled
                                                              heated:( BOOL)heated;


@end

/**
 * Describes transport contours and it's properties
 */
@interface YMKMasstransitTransportContour : NSObject

/**
 * Contour name
 */
@property (nonatomic, readonly, nonnull) NSString *name;

/**
 * Contour style; see YMKMasstransitTransportContourStyle.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) YMKMasstransitTransportContourStyle *style;


+ (nonnull YMKMasstransitTransportContour *)transportContourWithName:(nonnull NSString *)name
                                                               style:(nullable YMKMasstransitTransportContourStyle *)style;


@end

/**
 * Describes the style of transport contour objects
 */
@interface YMKMasstransitTransportContourStyle : NSObject

/**
 * Describes the main color of transport contour. Main color is used to
 * identify the object among others. For example, the color of MCD line
 * icon meant to be the main color of the contour. Presented in versions
 * for light and dark themes.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSNumber *mainColor;

/**
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSNumber *mainColorNight;


+ (nonnull YMKMasstransitTransportContourStyle *)styleWithMainColor:(nullable NSNumber *)mainColor
                                                     mainColorNight:(nullable NSNumber *)mainColorNight;


@end

/**
 * Describes a public transport stop.
 */
@interface YMKMasstransitStop : NSObject<YMKBaseMetadata>

/**
 * Stop ID.
 */
@property (nonatomic, readonly, nonnull) NSString *id;

/**
 * Stop name.
 */
@property (nonatomic, readonly, nonnull) NSString *name;

/**
 * Additional stop name. Can be a local number or specifying index.
 * Similar to thread description, but for stops
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSString *additionalName;

/**
 * Additional stop features.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) YMKMasstransitStopFeatureMask *features;

/**
 * Describes transport contours represented at this Stop.
 */
@property (nonatomic, readonly, nonnull) NSArray<YMKMasstransitTransportContour *> *transportContours;


+ (nonnull YMKMasstransitStop *)stopWithId:(nonnull NSString *)id
                                      name:(nonnull NSString *)name
                            additionalName:(nullable NSString *)additionalName
                                  features:(nullable YMKMasstransitStopFeatureMask *)features
                         transportContours:(nonnull NSArray<YMKMasstransitTransportContour *> *)transportContours;


@end

/**
 * Describes a public transport line.
 */
@interface YMKMasstransitLine : NSObject<YMKBaseMetadata>

/**
 * Line ID.
 */
@property (nonatomic, readonly, nonnull) NSString *id;

/**
 * Line name.
 */
@property (nonatomic, readonly, nonnull) NSString *name;

/**
 * List of line types. Starts from the most detailed, ends with the most
 * general.
 */
@property (nonatomic, readonly, nonnull) NSArray<NSString *> *vehicleTypes;

/**
 * Line style; see YMKMasstransitLineStyle.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) YMKMasstransitLineStyle *style;

/**
 * True if the line operates only at night.
 */
@property (nonatomic, readonly) BOOL isNight;

/**
 * URI for a line.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSString *uri;

/**
 * Subway short line name.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSString *shortName;

/**
 * Subway transport system ID.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSString *transportSystemId;


+ (nonnull YMKMasstransitLine *)lineWithId:(nonnull NSString *)id
                                      name:(nonnull NSString *)name
                              vehicleTypes:(nonnull NSArray<NSString *> *)vehicleTypes
                                     style:(nullable YMKMasstransitLineStyle *)style
                                   isNight:( BOOL)isNight
                                       uri:(nullable NSString *)uri
                                 shortName:(nullable NSString *)shortName
                         transportSystemId:(nullable NSString *)transportSystemId;


@end

/**
 * Describes the style of line.
 */
@interface YMKMasstransitLineStyle : NSObject

/**
 * Line color in #RRGGBB format.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSNumber *color;


+ (nonnull YMKMasstransitLineStyle *)styleWithColor:(nullable NSNumber *)color;


@end

/**
 * Describes a public transport thread. A thread is one of the
 * YMKMasstransitLine variants. For example, one line can have two
 * threads: direct and return.
 */
@interface YMKMasstransitThread : NSObject<YMKBaseMetadata>

/**
 * Thread ID.
 */
@property (nonatomic, readonly, nonnull) NSString *id;

/**
 * List of important stops on the thread, such as the first and last
 * stops.
 */
@property (nonatomic, readonly, nonnull) NSArray<YMKMasstransitStop *> *essentialStops;

/**
 * 'Description' is a specific thread name which must be used in
 * addition to the corresponding YMKMasstransitLine name.
 *
 * For example, line "bus 34" has two thread with descriptions: "short"
 * and "long". To get full thread name you should combine line name and
 * thread description. After this, you get two threads name: "bus 34
 * short" and "bus 34 long".
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSString *description;

/**
 * List of categories describing important traits of the thread. For
 * example, "primary", "secondary", "to_depot"
 */
@property (nonatomic, readonly, nonnull) NSArray<NSNumber *> *category;


+ (nonnull YMKMasstransitThread *)threadWithId:(nonnull NSString *)id
                                essentialStops:(nonnull NSArray<YMKMasstransitStop *> *)essentialStops
                                   description:(nullable NSString *)description
                                      category:(nonnull NSArray<NSNumber *> *)category;


@end
