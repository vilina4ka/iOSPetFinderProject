#import <YandexMapsMobile/YMKBaseMetadata.h>
#import <YandexMapsMobile/YMKGeometry.h>
#import <YandexMapsMobile/YMKJamSegment.h>
#import <YandexMapsMobile/YMKLocalizedValue.h>
#import <YandexMapsMobile/YMKMasstransitAnnotation.h>
#import <YandexMapsMobile/YMKMasstransitCommon.h>
#import <YandexMapsMobile/YMKMasstransitFare.h>
#import <YandexMapsMobile/YMKMasstransitFlags.h>
#import <YandexMapsMobile/YMKMasstransitTransport.h>
#import <YandexMapsMobile/YMKMasstransitTravelEstimation.h>
#import <YandexMapsMobile/YMKMasstransitWayPoint.h>
#import <YandexMapsMobile/YMKMasstransitWeight.h>
#import <YandexMapsMobile/YMKPoint.h>
#import <YandexMapsMobile/YMKRestrictedEntry.h>
#import <YandexMapsMobile/YMKUriObjectMetadata.h>

@class YMKMasstransitIndoorSegmentIndoorData;
@class YMKMasstransitRoute;
@class YMKMasstransitRouteMetadata;
@class YMKMasstransitSection;
@class YMKMasstransitSectionMetadataSectionData;

/**
 * Stairs direction of moving relative to the route.
 */
typedef NS_ENUM(NSUInteger, YMKMasstransitStairsDirection) {
    /**
     * Undocumented
     */
    YMKMasstransitStairsDirectionUnknown,
    /**
     * Undocumented
     */
    YMKMasstransitStairsDirectionUp,
    /**
     * Undocumented
     */
    YMKMasstransitStairsDirectionDown
};

/**
 * Undocumented
 */
typedef NS_ENUM(NSUInteger, YMKMasstransitPass) {
    /**
     * Underground crossing.
     */
    YMKMasstransitPassUnder,
    /**
     * Overground crossing, such as a bridge.
     */
    YMKMasstransitPassOver
};

/**
 * Travolator direction of moving relative to the route.
 */
typedef NS_ENUM(NSUInteger, YMKMasstransitTravolator) {
    /**
     * Undocumented
     */
    YMKMasstransitTravolatorUnknown,
    /**
     * Undocumented
     */
    YMKMasstransitTravolatorUp,
    /**
     * Undocumented
     */
    YMKMasstransitTravolatorDown
};

/**
 * Escalator direction of moving relative to the route.
 */
typedef NS_ENUM(NSUInteger, YMKMasstransitEscalator) {
    /**
     * Undocumented
     */
    YMKMasstransitEscalatorUnknown,
    /**
     * Undocumented
     */
    YMKMasstransitEscalatorUp,
    /**
     * Undocumented
     */
    YMKMasstransitEscalatorDown
};

/**
 * Elevator direction of moving relative to the route.
 */
typedef NS_ENUM(NSUInteger, YMKMasstransitElevator) {
    /**
     * Undocumented
     */
    YMKMasstransitElevatorUp,
    /**
     * Undocumented
     */
    YMKMasstransitElevatorDown
};

/**
 * TrafficTypeID describes who the road is designed for.
 */
typedef NS_ENUM(NSUInteger, YMKMasstransitTrafficTypeID) {
    /**
     * Road that is not one of the following types.
     */
    YMKMasstransitTrafficTypeIDOther,
    /**
     * Footpath, designed only for pedestrian travel.
     */
    YMKMasstransitTrafficTypeIDPedestrian,
    /**
     * Bikepath, designed only for bicycle travel.
     */
    YMKMasstransitTrafficTypeIDBicycle,
    /**
     * Road designed for motorized vehicles that might be dangerous for
     * cyclists.
     */
    YMKMasstransitTrafficTypeIDAuto
};

/**
 * Undocumented
 */
typedef NS_ENUM(NSUInteger, YMKMasstransitFitnessType) {
    /**
     * User moves on feet.
     */
    YMKMasstransitFitnessTypePedestrian,
    /**
     * User moves on wheels (bicycle, scooter).
     */
    YMKMasstransitFitnessTypeBicycle
};

/**
 * Rough estimate of user experience on a specific section of a fitness
 * route
 */
typedef NS_ENUM(NSUInteger, YMKMasstransitInclineType) {
    /**
     * Very quick elevation gain, difficult for any non-athlete
     */
    YMKMasstransitInclineTypeExtremeAscent,
    /**
     * Moderate elevation gain, could be difficult for some people
     */
    YMKMasstransitInclineTypeModerateAscent,
    /**
     * No meaningful elevation gain or loss,
     */
    YMKMasstransitInclineTypePlateau,
    /**
     * Moderate elevation loss
     */
    YMKMasstransitInclineTypeModerateDescent,
    /**
     * Very quick elevation loss, could be difficult or dangerous
     */
    YMKMasstransitInclineTypeExtremeDescent
};

/**
 * Undocumented
 */
typedef NS_ENUM(NSUInteger, YMKMasstransitComfortTag) {
    /**
     * Comfort route for hot weather.
     */
    YMKMasstransitComfortTagForHeat,
    /**
     * Comfort route for cold weather.
     */
    YMKMasstransitComfortTagForCold
};

/**
 * A listener to monitor changes to traffic jams on the route.
 */
@protocol YMKMasstransitRouteJamsListener <NSObject>

/**
 * Triggered when traffic jams are updated.
 */
- (void)onJamsUpdatedWithRoute:(nonnull YMKMasstransitRoute *)route;

/**
 * Triggered when traffic jams are outdated.
 */
- (void)onJamsOutdatedWithRoute:(nonnull YMKMasstransitRoute *)route;

@end

/**
 * Represents a 'wait until suitable tranport arrives' section of a
 * route.
 */
@interface YMKMasstransitWait : NSObject

/**
 * Dummy object.
 */
@property (nonatomic, readonly) NSUInteger dummy;


+ (nonnull YMKMasstransitWait *)waitWithDummy:( NSUInteger)dummy;


@end

/**
 * Represents stairs objects along the route
 */
@interface YMKMasstransitStairs : NSObject

/**
 * Undocumented
 */
@property (nonatomic, readonly) YMKMasstransitStairsDirection direction;

/**
 * Does stairs have a ramp
 */
@property (nonatomic, readonly) BOOL hasRamp;


+ (nonnull YMKMasstransitStairs *)stairsWithDirection:( YMKMasstransitStairsDirection)direction
                                              hasRamp:( BOOL)hasRamp;


@end

/**
 * Represents summary info about stairs along the route
 */
@interface YMKMasstransitStairsSummary : NSObject

/**
 * Number of stairs along the route.
 */
@property (nonatomic, readonly) NSUInteger numberOfStairs;

/**
 * Number of stairs with ramps along the route.
 */
@property (nonatomic, readonly) NSUInteger numberOfStairsWithRamp;


+ (nonnull YMKMasstransitStairsSummary *)stairsSummaryWithNumberOfStairs:( NSUInteger)numberOfStairs
                                                  numberOfStairsWithRamp:( NSUInteger)numberOfStairsWithRamp;


@end

/**
 * Constructions that can be found on pedestrian, bicycle paths or on
 * mass transit transfers.
 */
@interface YMKMasstransitConstructionMask : NSObject

/**
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) YMKMasstransitStairs *stairs;

/**
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSNumber *pass;

/**
 * Crossing that is not an underground tunnel or a bridge.
 */
@property (nonatomic, readonly) BOOL crosswalk;

/**
 * Edge connecting the route endpoint to the route network.
 */
@property (nonatomic, readonly) BOOL binding;

/**
 * Transfer. For example, transfer from one underground line to another
 * or transfer from an underground station to an exit from it.
 */
@property (nonatomic, readonly) BOOL transition;

/**
 * Tunnel that is not a crossing.
 */
@property (nonatomic, readonly) BOOL tunnel;

/**
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSNumber *travolator;

/**
 * Air-conditioned place. Can be a covered gallery, a mall or any other
 * climate-static edges.
 */
@property (nonatomic, readonly) BOOL indoor;

/**
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSNumber *escalator;

/**
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSNumber *elevator;


+ (nonnull YMKMasstransitConstructionMask *)constructionMaskWithStairs:(nullable YMKMasstransitStairs *)stairs
                                                                  pass:(nullable NSNumber *)pass
                                                             crosswalk:( BOOL)crosswalk
                                                               binding:( BOOL)binding
                                                            transition:( BOOL)transition
                                                                tunnel:( BOOL)tunnel
                                                            travolator:(nullable NSNumber *)travolator
                                                                indoor:( BOOL)indoor
                                                             escalator:(nullable NSNumber *)escalator
                                                              elevator:(nullable NSNumber *)elevator;


@end

/**
 * Describes part of pedestrian or bicycle path with the same
 * construction.
 */
@interface YMKMasstransitConstructionSegment : NSObject

/**
 * Undocumented
 */
@property (nonatomic, readonly, nonnull) YMKSubpolyline *subpolyline;

/**
 * Undocumented
 */
@property (nonatomic, readonly, nonnull) YMKMasstransitConstructionMask *constructionMask;


+ (nonnull YMKMasstransitConstructionSegment *)constructionSegmentWithSubpolyline:(nonnull YMKSubpolyline *)subpolyline
                                                                 constructionMask:(nonnull YMKMasstransitConstructionMask *)constructionMask;


@end

/**
 * Describes part of bicycle or scooter path with the same traffic type.
 */
@interface YMKMasstransitTrafficTypeSegment : NSObject

/**
 * Undocumented
 */
@property (nonatomic, readonly) YMKMasstransitTrafficTypeID trafficType;

/**
 * Undocumented
 */
@property (nonatomic, readonly, nonnull) YMKSubpolyline *subpolyline;


+ (nonnull YMKMasstransitTrafficTypeSegment *)trafficTypeSegmentWithTrafficType:( YMKMasstransitTrafficTypeID)trafficType
                                                                    subpolyline:(nonnull YMKSubpolyline *)subpolyline;


@end

/**
 * represents a section of continuous non-trivial gradient
 */
@interface YMKMasstransitInclineSection : NSObject

/**
 * Vague characteristic of this gradient secion
 */
@property (nonatomic, readonly) YMKMasstransitInclineType type;

/**
 * A subpolyline of the route where the section is located
 */
@property (nonatomic, readonly, nonnull) YMKSubpolyline *subpolyline;


+ (nonnull YMKMasstransitInclineSection *)inclineSectionWithType:( YMKMasstransitInclineType)type
                                                     subpolyline:(nonnull YMKSubpolyline *)subpolyline;


@end

/**
 * Information of elevation in point
 */
@interface YMKMasstransitElevationPoint : NSObject

/**
 * Elevation levels in meters
 */
@property (nonatomic, readonly) float elevation;


+ (nonnull YMKMasstransitElevationPoint *)elevationPointWithElevation:( float)elevation;


- (nonnull YMKMasstransitElevationPoint *)init;

@end

/**
 * Information of elevation gain in loss in a fitness section
 */
@interface YMKMasstransitElevationData : NSObject

/**
 * Total ascent in meters
 */
@property (nonatomic, readonly, nonnull) YMKLocalizedValue *totalAscent;

/**
 * Total descent in meters
 */
@property (nonatomic, readonly, nonnull) YMKLocalizedValue *totalDescent;

/**
 * The number of steps required to cover the distance for an average
 * person
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) YMKLocalizedValue *steps;

/**
 * The number of kilocalories consumed by an average person to cover the
 * distance
 */
@property (nonatomic, readonly, nonnull) YMKLocalizedValue *kilocalories;

/**
 * List of sections with notable incline
 */
@property (nonatomic, readonly, nonnull) NSArray<YMKMasstransitInclineSection *> *inclineSections;

/**
 * List of elevation for each point of the section polyline
 */
@property (nonatomic, readonly, nonnull) NSArray<YMKMasstransitElevationPoint *> *elevationSegments;


+ (nonnull YMKMasstransitElevationData *)elevationDataWithTotalAscent:(nonnull YMKLocalizedValue *)totalAscent
                                                         totalDescent:(nonnull YMKLocalizedValue *)totalDescent
                                                                steps:(nullable YMKLocalizedValue *)steps
                                                         kilocalories:(nonnull YMKLocalizedValue *)kilocalories
                                                      inclineSections:(nonnull NSArray<YMKMasstransitInclineSection *> *)inclineSections
                                                    elevationSegments:(nonnull NSArray<YMKMasstransitElevationPoint *> *)elevationSegments;


@end

/**
 * Indoor level (floor).
 */
@interface YMKMasstransitIndoorLevel : NSObject

/**
 * Level id that can be passed to the Router.
 */
@property (nonatomic, readonly, nonnull) NSString *levelId;

/**
 * Localized level name.
 */
@property (nonatomic, readonly, nonnull) NSString *levelName;


+ (nonnull YMKMasstransitIndoorLevel *)indoorLevelWithLevelId:(nonnull NSString *)levelId
                                                    levelName:(nonnull NSString *)levelName;


@end

/**
 * Connectors connect two floors, indoor and outdoor, two indoor plans.
 * Connectors do not have single level id and name but still are
 * considered a part of the indoor plan. Examples: stairs, elevators,
 * escalators, travolators, transitions, route segment that goes from
 * outdoor to indoor (through the entrance) and vica versa.
 */
@interface YMKMasstransitConnector : NSObject

/**
 * A level (floor) where the connector begins. Null means outdoor.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) YMKMasstransitIndoorLevel *from;

/**
 * A level (floor) where the connector ends. Null means outdoor.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) YMKMasstransitIndoorLevel *to;


+ (nonnull YMKMasstransitConnector *)connectorWithFrom:(nullable YMKMasstransitIndoorLevel *)from
                                                    to:(nullable YMKMasstransitIndoorLevel *)to;


@end

/**
 * Indoor segment of the fitness section.
 */
@interface YMKMasstransitIndoorSegment : NSObject

/**
 * Undocumented
 */
@property (nonatomic, readonly, nonnull) YMKMasstransitIndoorSegmentIndoorData *indoorData;

/**
 * A span of this level on the route geometry.
 */
@property (nonatomic, readonly, nonnull) YMKSubpolyline *subpolyline;


+ (nonnull YMKMasstransitIndoorSegment *)indoorSegmentWithIndoorData:(nonnull YMKMasstransitIndoorSegmentIndoorData *)indoorData
                                                         subpolyline:(nonnull YMKSubpolyline *)subpolyline;


@end

/**
 * Undocumented
 */
@interface YMKMasstransitIndoorSegmentIndoorData : NSObject

@property (nonatomic, readonly, nullable) YMKMasstransitIndoorLevel *indoorLevel;

@property (nonatomic, readonly, nullable) YMKMasstransitConnector *connector;

+ (nonnull YMKMasstransitIndoorSegmentIndoorData *)indoorDataWithIndoorLevel:(nonnull YMKMasstransitIndoorLevel *)indoorLevel;

+ (nonnull YMKMasstransitIndoorSegmentIndoorData *)indoorDataWithConnector:(nonnull YMKMasstransitConnector *)connector;

@end


/**
 * Represent a section where we have to move by ourself (like
 * pedestrian, or by bicycle and scooter)
 */
@interface YMKMasstransitFitness : NSObject

/**
 * Undocumented
 */
@property (nonatomic, readonly) YMKMasstransitFitnessType type;

/**
 * Compressed information about constructions along the path.
 * YMKMasstransitConstructionSegment::subpolyline fields of all segments
 * cover the entire geometry of corresponding section".
 */
@property (nonatomic, readonly, nonnull) NSArray<YMKMasstransitConstructionSegment *> *constructions;

/**
 * List of restricted entries with their coordinates along the path.
 */
@property (nonatomic, readonly, nonnull) NSArray<YMKRestrictedEntry *> *restrictedEntries;

/**
 * List of via points on the path. A via point is described by the index
 * of the point in the route geometry polyline.
 */
@property (nonatomic, readonly, nonnull) NSArray<YMKPolylinePosition *> *viaPoints;

/**
 * List of annotations on the path.
 */
@property (nonatomic, readonly, nonnull) NSArray<YMKMasstransitAnnotation *> *annotations;

/**
 * List of traffic types on path
 */
@property (nonatomic, readonly, nonnull) NSArray<YMKMasstransitTrafficTypeSegment *> *trafficTypes;

/**
 * Information on elevation gain and loss in a fitness section
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) YMKMasstransitElevationData *elevationData;

/**
 * List of indoor segments (levels or connectors) on path. Compressed
 * information about levels along the path.
 * YMKMasstransitIndoorSegment::subpolyline fields of all indoor
 * segments cover only the indoor geometry, it does not cover outdoor
 * parts.
 */
@property (nonatomic, readonly, nonnull) NSArray<YMKMasstransitIndoorSegment *> *indoorSegments;


+ (nonnull YMKMasstransitFitness *)fitnessWithType:( YMKMasstransitFitnessType)type
                                     constructions:(nonnull NSArray<YMKMasstransitConstructionSegment *> *)constructions
                                 restrictedEntries:(nonnull NSArray<YMKRestrictedEntry *> *)restrictedEntries
                                         viaPoints:(nonnull NSArray<YMKPolylinePosition *> *)viaPoints
                                       annotations:(nonnull NSArray<YMKMasstransitAnnotation *> *)annotations
                                      trafficTypes:(nonnull NSArray<YMKMasstransitTrafficTypeSegment *> *)trafficTypes
                                     elevationData:(nullable YMKMasstransitElevationData *)elevationData
                                    indoorSegments:(nonnull NSArray<YMKMasstransitIndoorSegment *> *)indoorSegments;


@end

/**
 * The metadata about the mass transit stop.
 */
@interface YMKMasstransitRouteStopMetadata : NSObject<YMKBaseMetadata>

/**
 * Route stop information.
 */
@property (nonatomic, readonly, nonnull) YMKMasstransitStop *stop;

/**
 * Underground station exit
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) YMKMasstransitStop *stopExit;

/**
 * Coordinates of underground station exit
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) YMKPoint *exitPoint;


+ (nonnull YMKMasstransitRouteStopMetadata *)routeStopMetadataWithStop:(nonnull YMKMasstransitStop *)stop
                                                              stopExit:(nullable YMKMasstransitStop *)stopExit
                                                             exitPoint:(nullable YMKPoint *)exitPoint;


@end

/**
 * Describes a YMKMasstransitStop on a YMKMasstransitRoute.
 */
@interface YMKMasstransitRouteStop : NSObject

/**
 * General information about a stop on a route and optionally about its
 * exit
 */
@property (nonatomic, readonly, nonnull) YMKMasstransitRouteStopMetadata *metadata;

/**
 * Coordinates of the stop.
 */
@property (nonatomic, readonly, nonnull) YMKPoint *position;


+ (nonnull YMKMasstransitRouteStop *)routeStopWithMetadata:(nonnull YMKMasstransitRouteStopMetadata *)metadata
                                                  position:(nonnull YMKPoint *)position;


@end

/**
 * Represents a stop in path which is not a part of any transport trip
 * but must be visited according travelling. For example, exit from
 * subway may require transfer on other stop.
 */
@interface YMKMasstransitTransferStop : NSObject

/**
 * Stop information.
 */
@property (nonatomic, readonly, nonnull) YMKMasstransitRouteStop *routeStop;

/**
 * Transports at the stops
 */
@property (nonatomic, readonly, nonnull) NSArray<YMKMasstransitTransport *> *transports;


+ (nonnull YMKMasstransitTransferStop *)transferStopWithRouteStop:(nonnull YMKMasstransitRouteStop *)routeStop
                                                       transports:(nonnull NSArray<YMKMasstransitTransport *> *)transports;


@end

/**
 * Represents a transfer to another mass transit line or to another
 * stop. For example, transfer from one underground line to another.
 */
@interface YMKMasstransitTransfer : NSObject

/**
 * Compressed information about pedestrian constructions along the
 * transfer path. YMKMasstransitConstructionSegment::subpolyline fields
 * of all segments cover the entire geometry of corresponding section".
 */
@property (nonatomic, readonly, nonnull) NSArray<YMKMasstransitConstructionSegment *> *constructions;

/**
 * The stop you need to transfer to
 */
@property (nonatomic, readonly, nonnull) YMKMasstransitTransferStop *transferStop;


+ (nonnull YMKMasstransitTransfer *)transferWithConstructions:(nonnull NSArray<YMKMasstransitConstructionSegment *> *)constructions
                                                 transferStop:(nonnull YMKMasstransitTransferStop *)transferStop;


@end

/**
 * Represents a taxi part of route.
 */
@interface YMKMasstransitTaxi : NSObject

/**
 * Traffic conditions on the given part of route.
 */
@property (nonatomic, readonly, nonnull) NSArray<YMKJamSegment *> *jamSegments;


+ (nonnull YMKMasstransitTaxi *)taxiWithJamSegments:(nonnull NSArray<YMKJamSegment *> *)jamSegments;


@end

/**
 * General information about a section of a route. The
 * YMKMasstransitSectionMetadata::data field describes the type of
 * section: wait, walk, transfer, or transport, and related data.
 * Related data can be set for walk and transfer sections. This data is
 * a vector of construction types of corresponding geometry segments.
 */
@interface YMKMasstransitSectionMetadata : NSObject

/**
 * Contains the route traveling time, distance of the walking part, and
 * the number of transfers.
 */
@property (nonatomic, readonly, nonnull) YMKMasstransitWeight *weight;

/**
 * Contains information that is specific to a section type: wait, walk,
 * transfer, or ride transport.
 */
@property (nonatomic, readonly, nonnull) YMKMasstransitSectionMetadataSectionData *data;

/**
 * Arrival and departure time estimations. This field is set only for
 * time-dependent routes.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) YMKMasstransitTravelEstimation *estimation;

/**
 * Part of the route polyline for the route leg. A leg is a part of the
 * route between two consecutive waypoints.
 */
@property (nonatomic, readonly) NSUInteger legIndex;

/**
 * List of payment options with prices for the current section.
 */
@property (nonatomic, readonly, nonnull) NSArray<YMKMasstransitSectionPaymentOption *> *paymentOptions;


+ (nonnull YMKMasstransitSectionMetadata *)sectionMetadataWithWeight:(nonnull YMKMasstransitWeight *)weight
                                                                data:(nonnull YMKMasstransitSectionMetadataSectionData *)data
                                                          estimation:(nullable YMKMasstransitTravelEstimation *)estimation
                                                            legIndex:( NSUInteger)legIndex
                                                      paymentOptions:(nonnull NSArray<YMKMasstransitSectionPaymentOption *> *)paymentOptions;


@end

/**
 * A choice of information specific to the section type.
 */
@interface YMKMasstransitSectionMetadataSectionData : NSObject

@property (nonatomic, readonly, nullable) YMKMasstransitWait *wait;

@property (nonatomic, readonly, nullable) YMKMasstransitFitness *fitness;

@property (nonatomic, readonly, nullable) YMKMasstransitTransfer *transfer;

@property (nonatomic, readonly, nullable) YMKMasstransitTaxi *taxi;

@property (nonatomic, readonly, nullable) NSArray<YMKMasstransitTransport *> *transports;

+ (nonnull YMKMasstransitSectionMetadataSectionData *)sectionDataWithWait:(nonnull YMKMasstransitWait *)wait;

+ (nonnull YMKMasstransitSectionMetadataSectionData *)sectionDataWithFitness:(nonnull YMKMasstransitFitness *)fitness;

+ (nonnull YMKMasstransitSectionMetadataSectionData *)sectionDataWithTransfer:(nonnull YMKMasstransitTransfer *)transfer;

+ (nonnull YMKMasstransitSectionMetadataSectionData *)sectionDataWithTaxi:(nonnull YMKMasstransitTaxi *)taxi;

+ (nonnull YMKMasstransitSectionMetadataSectionData *)sectionDataWithTransports:(nonnull NSArray<YMKMasstransitTransport *> *)transports;

@end


/**
 * Route settings that were used by the mass transit router for a
 * specific route.
 */
@interface YMKMasstransitRouteSettings : NSObject

/**
 * Transport types that the router avoided.
 */
@property (nonatomic, readonly, nonnull) NSArray<NSString *> *avoidTypes;

/**
 * Transport types that were allowed even if they are in the list of
 * avoided types.
 */
@property (nonatomic, readonly, nonnull) NSArray<NSString *> *acceptTypes;


+ (nonnull YMKMasstransitRouteSettings *)routeSettingsWithAvoidTypes:(nonnull NSArray<NSString *> *)avoidTypes
                                                         acceptTypes:(nonnull NSArray<NSString *> *)acceptTypes;


@end

/**
 * Contains information associated with a route constructed by the mass
 * transit router.
 */
@interface YMKMasstransitRouteMetadata : NSObject<YMKBaseMetadata>

/**
 * Contains the route time, distance of the walking part, and the number
 * of transfers.
 */
@property (nonatomic, readonly, nonnull) YMKMasstransitWeight *weight;

/**
 * Route settings that were used by the mass transit router.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) YMKMasstransitRouteSettings *settings;

/**
 * Arrival and departure time estimations for time-dependent routes.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) YMKMasstransitTravelEstimation *estimation;

/**
 * List of route waypoints. See YMKMasstransitWayPoint for details
 */
@property (nonatomic, readonly, nonnull) NSArray<YMKMasstransitWayPoint *> *wayPoints;

/**
 * Unique route id.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSString *routeId;

/**
 * Flags which contains route properties
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) YMKMasstransitFlags *flags;

/**
 * Undocumented
 */
@property (nonatomic, readonly, nonnull) NSArray<NSNumber *> *comfortTags;

/**
 * Undocumented
 */
@property (nonatomic, readonly, nonnull) YMKMasstransitStairsSummary *stairsSummary;

/**
 * List of payment options with prices for the whole route.
 */
@property (nonatomic, readonly, nonnull) NSArray<YMKMasstransitRoutePaymentOption *> *paymentOptions;


+ (nonnull YMKMasstransitRouteMetadata *)routeMetadataWithWeight:(nonnull YMKMasstransitWeight *)weight
                                                        settings:(nullable YMKMasstransitRouteSettings *)settings
                                                      estimation:(nullable YMKMasstransitTravelEstimation *)estimation
                                                       wayPoints:(nonnull NSArray<YMKMasstransitWayPoint *> *)wayPoints
                                                         routeId:(nullable NSString *)routeId
                                                           flags:(nullable YMKMasstransitFlags *)flags
                                                     comfortTags:(nonnull NSArray<NSNumber *> *)comfortTags
                                                   stairsSummary:(nonnull YMKMasstransitStairsSummary *)stairsSummary
                                                  paymentOptions:(nonnull NSArray<YMKMasstransitRoutePaymentOption *> *)paymentOptions;


@end

/**
 * Contains information about an individual section of a mass transit
 * YMKMasstransitRoute. The only fields that are always set are
 * YMKMasstransitSection::metadata.YMKMasstransitSectionMetadata::weight,
 * YMKMasstransitSection::geometry and
 * YMKMasstransitSection::metadata.YMKMasstransitSectionMetadata::data.
 */
@interface YMKMasstransitSection : NSObject

/**
 * General information about a section of a route.
 */
@property (nonatomic, readonly, nonnull) YMKMasstransitSectionMetadata *metadata;

/**
 * Geometry of the section as a fragment of a YMKMasstransitRoute
 * polyline.
 */
@property (nonatomic, readonly, nonnull) YMKSubpolyline *geometry;

/**
 * Vector of stops along the route. The first stop in the vector is the
 * stop for boarding the transport, and the last stop in the vector is
 * the stop for exiting the transport.
 */
@property (nonatomic, readonly, nonnull) NSArray<YMKMasstransitRouteStop *> *stops;

/**
 * Vector of polylines each connecting two consecutive stops. This
 * vector is only filled for mass transit ride sections, so this
 * geometry represents a part of the mass transit thread geometry
 * between two stops.
 */
@property (nonatomic, readonly, nonnull) NSArray<YMKSubpolyline *> *rideLegs;


+ (nonnull YMKMasstransitSection *)sectionWithMetadata:(nonnull YMKMasstransitSectionMetadata *)metadata
                                              geometry:(nonnull YMKSubpolyline *)geometry
                                                 stops:(nonnull NSArray<YMKMasstransitRouteStop *> *)stops
                                              rideLegs:(nonnull NSArray<YMKSubpolyline *> *)rideLegs;


@end

/**
 * Contains information about a route constructed by the mass transit
 * router.
 */
@interface YMKMasstransitRoute : NSObject
/**
 * General route information.
 */
@property (nonatomic, readonly, nonnull) YMKMasstransitRouteMetadata *metadata;
/**
 * List of route waypoints. See YMKMasstransitWayPoint for details
 */
@property (nonatomic, readonly, nonnull) NSArray<YMKMasstransitWayPoint *> *wayPoints;
/**
 * Vector of sections of the route.
 */
@property (nonatomic, readonly, nonnull) NSArray<YMKMasstransitSection *> *sections;
/**
 * Polyline of the entire route.
 */
@property (nonatomic, readonly, nonnull) YMKPolyline *geometry;
/**
 * Route URI, which can be used with YMKMasstransitRouter to fetch
 * additional information about the route or can be bookmarked for
 * future reference.
 */
@property (nonatomic, readonly, nonnull) YMKUriObjectMetadata *uriMetadata;

/**
 * Return distance between two polyline positions.
 */
- (double)distanceBetweenPolylinePositionsWithFrom:(nonnull YMKPolylinePosition *)from
                                                to:(nonnull YMKPolylinePosition *)to;

@end
