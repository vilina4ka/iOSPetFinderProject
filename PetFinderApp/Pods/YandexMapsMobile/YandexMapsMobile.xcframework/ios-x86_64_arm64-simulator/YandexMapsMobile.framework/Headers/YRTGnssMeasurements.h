#import <Foundation/Foundation.h>

@class YRTGnssMeasurementsEvent;

/**
 * :nodoc:
 */
@protocol YRTGnssMeasurementsEventsPlatformProvider <NSObject>

/**
 * Undocumented
 */
- (void)finish;

@end

/**
 * :nodoc:
 */
@interface YRTGnssClock : NSObject

/**
 * Undocumented
 */
@property (nonatomic, readonly) long long timeNanos;

/**
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSNumber *timeUncertaintyNanos;

/**
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSNumber *leapSecond;

/**
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSNumber *fullBiasNanos;

/**
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSNumber *biasNanos;

/**
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSNumber *biasUncertaintyNanos;

/**
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSNumber *driftNanosPerSecond;

/**
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSNumber *driftNanosUncertaintyPerSecond;

/**
 * Undocumented
 */
@property (nonatomic, readonly) NSInteger hardwareClockDiscontinuityCount;


+ (nonnull YRTGnssClock *)gnssClockWithTimeNanos:( long long)timeNanos
                            timeUncertaintyNanos:(nullable NSNumber *)timeUncertaintyNanos
                                      leapSecond:(nullable NSNumber *)leapSecond
                                   fullBiasNanos:(nullable NSNumber *)fullBiasNanos
                                       biasNanos:(nullable NSNumber *)biasNanos
                            biasUncertaintyNanos:(nullable NSNumber *)biasUncertaintyNanos
                             driftNanosPerSecond:(nullable NSNumber *)driftNanosPerSecond
                  driftNanosUncertaintyPerSecond:(nullable NSNumber *)driftNanosUncertaintyPerSecond
                 hardwareClockDiscontinuityCount:( NSInteger)hardwareClockDiscontinuityCount;


@end

/**
 * :nodoc:
 */
@interface YRTGnssMeasurement : NSObject

/**
 * Undocumented
 */
@property (nonatomic, readonly) NSInteger constellationType;

/**
 * Undocumented
 */
@property (nonatomic, readonly) NSInteger svid;

/**
 * Undocumented
 */
@property (nonatomic, readonly) double accumulatedDeltaRangeMeters;

/**
 * Undocumented
 */
@property (nonatomic, readonly) NSInteger accumulatedDeltaRangeState;

/**
 * Undocumented
 */
@property (nonatomic, readonly) double accumulatedDeltaRangeUncertaintyMeters;

/**
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSNumber *carrierFrequencyHz;

/**
 * Undocumented
 */
@property (nonatomic, readonly) double cn0DbHz;

/**
 * Undocumented
 */
@property (nonatomic, readonly) double pseudorangeRateMetersPerSecond;

/**
 * Undocumented
 */
@property (nonatomic, readonly) double pseudorangeRateUncertaintyMetersPerSecond;

/**
 * Undocumented
 */
@property (nonatomic, readonly) long long receivedSvTimeNanos;

/**
 * Undocumented
 */
@property (nonatomic, readonly) long long receivedSvTimeUncertaintyNanos;

/**
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSNumber *snrInDb;

/**
 * Undocumented
 */
@property (nonatomic, readonly) NSInteger state;

/**
 * Undocumented
 */
@property (nonatomic, readonly) double timeOffsetNanos;

/**
 * Undocumented
 */
@property (nonatomic, readonly) NSInteger multipathIndicator;

/**
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSNumber *carrierCycles;

/**
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSNumber *carrierPhase;

/**
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSNumber *carrierPhaseUncertainty;


+ (nonnull YRTGnssMeasurement *)gnssMeasurementWithConstellationType:( NSInteger)constellationType
                                                                svid:( NSInteger)svid
                                         accumulatedDeltaRangeMeters:( double)accumulatedDeltaRangeMeters
                                          accumulatedDeltaRangeState:( NSInteger)accumulatedDeltaRangeState
                              accumulatedDeltaRangeUncertaintyMeters:( double)accumulatedDeltaRangeUncertaintyMeters
                                                  carrierFrequencyHz:(nullable NSNumber *)carrierFrequencyHz
                                                             cn0DbHz:( double)cn0DbHz
                                      pseudorangeRateMetersPerSecond:( double)pseudorangeRateMetersPerSecond
                           pseudorangeRateUncertaintyMetersPerSecond:( double)pseudorangeRateUncertaintyMetersPerSecond
                                                 receivedSvTimeNanos:( long long)receivedSvTimeNanos
                                      receivedSvTimeUncertaintyNanos:( long long)receivedSvTimeUncertaintyNanos
                                                             snrInDb:(nullable NSNumber *)snrInDb
                                                               state:( NSInteger)state
                                                     timeOffsetNanos:( double)timeOffsetNanos
                                                  multipathIndicator:( NSInteger)multipathIndicator
                                                       carrierCycles:(nullable NSNumber *)carrierCycles
                                                        carrierPhase:(nullable NSNumber *)carrierPhase
                                             carrierPhaseUncertainty:(nullable NSNumber *)carrierPhaseUncertainty;


@end

/**
 * :nodoc:
 */
@interface YRTGnssMeasurementsEvent : NSObject

/**
 * Undocumented
 */
@property (nonatomic, readonly, nonnull) YRTGnssClock *clock;

/**
 * Undocumented
 */
@property (nonatomic, readonly, nonnull) NSArray<YRTGnssMeasurement *> *measurements;


+ (nonnull YRTGnssMeasurementsEvent *)gnssMeasurementsEventWithClock:(nonnull YRTGnssClock *)clock
                                                        measurements:(nonnull NSArray<YRTGnssMeasurement *> *)measurements;


@end

/**
 * :nodoc:
 */
@interface YRTGnssMeasurementsEventsNativeListener : NSObject

/**
 * Undocumented
 */
- (void)onGnssMeasurementsEventWithEvent:(nonnull YRTGnssMeasurementsEvent *)event;

@end
