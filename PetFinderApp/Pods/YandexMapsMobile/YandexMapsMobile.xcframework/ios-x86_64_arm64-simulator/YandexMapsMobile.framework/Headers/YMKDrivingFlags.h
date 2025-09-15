#import <Foundation/Foundation.h>

/**
 * Overall characteristics of the route.
 */
@interface YMKDrivingFlags : NSObject

/**
 * Route is blocked.
 */
@property (nonatomic, readonly) BOOL blocked;

/**
 * Route has ferries on it.
 */
@property (nonatomic, readonly) BOOL hasFerries;

/**
 * Route has toll posts, which are always paid.
 */
@property (nonatomic, readonly) BOOL hasTolls;

/**
 * Route requires special access.
 */
@property (nonatomic, readonly) BOOL requiresAccessPass;

/**
 * Route is made for parking.
 */
@property (nonatomic, readonly) BOOL forParking;

/**
 * Route will be blocked soon.
 */
@property (nonatomic, readonly) BOOL futureBlocked;

/**
 * Route has a severe traffic jam.
 */
@property (nonatomic, readonly) BOOL deadJam;

/**
 * Route was built by using offline data.
 */
@property (nonatomic, readonly) BOOL builtOffline;

/**
 * Predicted optimal route.
 */
@property (nonatomic, readonly) BOOL predicted;

/**
 * Route has rugged roads on it.
 */
@property (nonatomic, readonly) BOOL hasRuggedRoads;

/**
 * Route has ford crossing on it.
 */
@property (nonatomic, readonly) BOOL hasFordCrossing;

/**
 * Route has vehicle restrictions on it.
 */
@property (nonatomic, readonly) BOOL hasVehicleRestrictions;

/**
 * Route has unpaved roads on it.
 */
@property (nonatomic, readonly) BOOL hasUnpavedRoads;

/**
 * Route has poor condition roads on it.
 */
@property (nonatomic, readonly) BOOL hasInPoorConditionRoads;

/**
 * Route has railway crossing on it.
 */
@property (nonatomic, readonly) BOOL hasRailwayCrossing;

/**
 * Route has checkpoints on it.
 */
@property (nonatomic, readonly) BOOL hasCheckpoints;

/**
 * Route was requested with custom departure time.
 */
@property (nonatomic, readonly) BOOL scheduledDeparture;

/**
 * Route has conditionally-toll-free toll posts
 */
@property (nonatomic, readonly) BOOL hasNonTransactionalTolls;

/**
 * Route has tunnels on it.
 */
@property (nonatomic, readonly) BOOL hasTunnels;

/**
 * Route has highways on it.
 */
@property (nonatomic, readonly) BOOL hasHighways;


+ (nonnull YMKDrivingFlags *)flagsWithBlocked:( BOOL)blocked
                                   hasFerries:( BOOL)hasFerries
                                     hasTolls:( BOOL)hasTolls
                           requiresAccessPass:( BOOL)requiresAccessPass
                                   forParking:( BOOL)forParking
                                futureBlocked:( BOOL)futureBlocked
                                      deadJam:( BOOL)deadJam
                                 builtOffline:( BOOL)builtOffline
                                    predicted:( BOOL)predicted
                               hasRuggedRoads:( BOOL)hasRuggedRoads
                              hasFordCrossing:( BOOL)hasFordCrossing
                       hasVehicleRestrictions:( BOOL)hasVehicleRestrictions
                              hasUnpavedRoads:( BOOL)hasUnpavedRoads
                      hasInPoorConditionRoads:( BOOL)hasInPoorConditionRoads
                           hasRailwayCrossing:( BOOL)hasRailwayCrossing
                               hasCheckpoints:( BOOL)hasCheckpoints
                           scheduledDeparture:( BOOL)scheduledDeparture
                     hasNonTransactionalTolls:( BOOL)hasNonTransactionalTolls
                                   hasTunnels:( BOOL)hasTunnels
                                  hasHighways:( BOOL)hasHighways;


@end
