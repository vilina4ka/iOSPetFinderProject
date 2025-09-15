#import <YandexMapsMobile/YMKMasstransitCommon.h>
#import <YandexMapsMobile/YMKTime.h>

@class YMKMasstransitBoardingOptionsBoardingArea;
@class YMKMasstransitTransportThreadAlertClosed;
@class YMKMasstransitTransportThreadAlertClosedUntil;
@class YMKMasstransitTransportThreadAlertLastTrip;
@class YMKMasstransitTransportTransportThread;

/**
 * TransportThreadAlert are important annotations for mass transit ride
 * sections of routes.
 */
@interface YMKMasstransitTransportThreadAlert : NSObject

/**
 * Standard alert text. Simple clients could use this text to get a
 * pre-formatted message. If the client is unable to recognize the known
 * structured alert, it should use the text field instead.
 */
@property (nonatomic, readonly, nonnull) NSString *text;

/**
 * The value is set if the thread is not operational on that day. Only
 * one of the values close, closedUntil and lastTrip is set for an
 * alert.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) YMKMasstransitTransportThreadAlertClosed *closed;

/**
 * The value is set if the thread is not operational until the specified
 * time. Only one of the values close, closedUntil and lastTrip is set
 * for an alert.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) YMKMasstransitTransportThreadAlertClosedUntil *closedUntil;

/**
 * The value is set if this trip is the last trip for the thread. Only
 * one of the values close, closedUntil and lastTrip is set for an
 * alert.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) YMKMasstransitTransportThreadAlertLastTrip *lastTrip;


+ (nonnull YMKMasstransitTransportThreadAlert *)transportThreadAlertWithText:(nonnull NSString *)text
                                                                      closed:(nullable YMKMasstransitTransportThreadAlertClosed *)closed
                                                                 closedUntil:(nullable YMKMasstransitTransportThreadAlertClosedUntil *)closedUntil
                                                                    lastTrip:(nullable YMKMasstransitTransportThreadAlertLastTrip *)lastTrip;


@end

/**
 * Thread is not operational on that day.
 */
@interface YMKMasstransitTransportThreadAlertClosed : NSObject

/**
 * Dummy field which is used here because IDL does not support structs
 * without fields.
 */
@property (nonatomic, readonly) BOOL dummy;


+ (nonnull YMKMasstransitTransportThreadAlertClosed *)closedWithDummy:( BOOL)dummy;


@end

/**
 * Thread is not operational until specified time.
 */
@interface YMKMasstransitTransportThreadAlertClosedUntil : NSObject

/**
 * Time of the next trip.
 */
@property (nonatomic, readonly, nonnull) YMKTime *time;


+ (nonnull YMKMasstransitTransportThreadAlertClosedUntil *)closedUntilWithTime:(nonnull YMKTime *)time;


@end

/**
 * Last trip for the thread. Allows to get the time it takes to get to
 * the end of the route.
 */
@interface YMKMasstransitTransportThreadAlertLastTrip : NSObject

/**
 * Time required to finish the trip.
 */
@property (nonatomic, readonly, nonnull) YMKTime *time;


+ (nonnull YMKMasstransitTransportThreadAlertLastTrip *)lastTripWithTime:(nonnull YMKTime *)time;


@end

/**
 * Contains information about underground boarding recommendations.
 */
@interface YMKMasstransitBoardingOptions : NSObject

/**
 * Vector of recommended areas to board.
 */
@property (nonatomic, readonly, nonnull) NSArray<YMKMasstransitBoardingOptionsBoardingArea *> *area;


+ (nonnull YMKMasstransitBoardingOptions *)boardingOptionsWithArea:(nonnull NSArray<YMKMasstransitBoardingOptionsBoardingArea *> *)area;


@end

/**
 * Area recommended for boarding: wagon, sector, etc.
 */
@interface YMKMasstransitBoardingOptionsBoardingArea : NSObject

/**
 * Machine-readable non-localisable boarding area identifier.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSString *id;


+ (nonnull YMKMasstransitBoardingOptionsBoardingArea *)boardingAreaWithId:(nullable NSString *)id;


@end

/**
 * Contains information about the mass transit ride section of a
 * YMKMasstransitRoute for a specific mass transit YMKMasstransitLine.
 */
@interface YMKMasstransitTransport : NSObject

/**
 * Mass transit line.
 */
@property (nonatomic, readonly, nonnull) YMKMasstransitLine *line;

/**
 * Collection of mass transit threads of the specified line suitable for
 * the constructed route.
 */
@property (nonatomic, readonly, nonnull) NSArray<YMKMasstransitTransportTransportThread *> *transports;

/**
 * Describes YMKMasstransitTransportContour in borders of which this
 * block is located
 */
@property (nonatomic, readonly, nonnull) NSArray<YMKMasstransitTransportContour *> *transportContours;


+ (nonnull YMKMasstransitTransport *)transportWithLine:(nonnull YMKMasstransitLine *)line
                                            transports:(nonnull NSArray<YMKMasstransitTransportTransportThread *> *)transports
                                     transportContours:(nonnull NSArray<YMKMasstransitTransportContour *> *)transportContours;


@end

/**
 * YMKMasstransitThread specific properties of a mass transit ride
 * section of a YMKMasstransitRoute.
 */
@interface YMKMasstransitTransportTransportThread : NSObject

/**
 * Mass transit thread.
 */
@property (nonatomic, readonly, nonnull) YMKMasstransitThread *thread;

/**
 * Indicates that the mass transit router considers this thread the best
 * one for the current section of the constucted route.
 */
@property (nonatomic, readonly) BOOL isRecommended;

/**
 * Collection of important annotations for the section.
 */
@property (nonatomic, readonly, nonnull) NSArray<YMKMasstransitTransportThreadAlert *> *alerts;

/**
 * If alternateDepartureStop is specified, it specifies the departure
 * location for this particular Thread instead of the first Stop of the
 * Section.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) YMKMasstransitStop *alternateDepartureStop;

/**
 * Recommended underground boarding options for this section.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) YMKMasstransitBoardingOptions *boardingOptions;


+ (nonnull YMKMasstransitTransportTransportThread *)transportThreadWithThread:(nonnull YMKMasstransitThread *)thread
                                                                isRecommended:( BOOL)isRecommended
                                                                       alerts:(nonnull NSArray<YMKMasstransitTransportThreadAlert *> *)alerts
                                                       alternateDepartureStop:(nullable YMKMasstransitStop *)alternateDepartureStop
                                                              boardingOptions:(nullable YMKMasstransitBoardingOptions *)boardingOptions;


@end
