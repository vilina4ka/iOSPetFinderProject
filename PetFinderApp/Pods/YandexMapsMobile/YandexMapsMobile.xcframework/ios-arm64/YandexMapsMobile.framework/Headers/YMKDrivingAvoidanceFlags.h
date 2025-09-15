#import <Foundation/Foundation.h>

/**
 * Undocumented
 */
@interface YMKDrivingAvoidanceFlags : NSObject

/**
 * The 'avoidTolls' option instructs the router to return routes that
 * avoid tolls when possible.
 */
@property (nonatomic, assign) BOOL avoidTolls;

/**
 * The 'avoidUnpaved' option instructs the router to return routes that
 * avoid unpaved roads when possible.
 */
@property (nonatomic, assign) BOOL avoidUnpaved;

/**
 * The 'avoidPoorCondition' option instructs the router to return routes
 * that avoid roads in poor conditions when possible.
 */
@property (nonatomic, assign) BOOL avoidPoorCondition;

/**
 * The 'avoidPoorConditions' option instructs the router to return
 * routes that avoid railway crossings when possible.
 */
@property (nonatomic, assign) BOOL avoidRailwayCrossing;

/**
 * The 'avoidBoatFerry' option instructs the router to return routes
 * that avoid ferries when possible.
 */
@property (nonatomic, assign) BOOL avoidBoatFerry;

/**
 * The 'avoidFordCrossing' option instructs the router to return routes
 * that avoid ford crossings when possible.
 */
@property (nonatomic, assign) BOOL avoidFordCrossing;

/**
 * The 'avoidTunnel' option instructs the router to return routes that
 * avoid tunnels when possible.
 */
@property (nonatomic, assign) BOOL avoidTunnel;

/**
 * The 'avoidHighway' option instructs the router to return routes that
 * avoid highways when possible.
 */
@property (nonatomic, assign) BOOL avoidHighway;

+ (nonnull YMKDrivingAvoidanceFlags *)avoidanceFlagsWithAvoidTolls:( BOOL)avoidTolls
                                                      avoidUnpaved:( BOOL)avoidUnpaved
                                                avoidPoorCondition:( BOOL)avoidPoorCondition
                                              avoidRailwayCrossing:( BOOL)avoidRailwayCrossing
                                                    avoidBoatFerry:( BOOL)avoidBoatFerry
                                                 avoidFordCrossing:( BOOL)avoidFordCrossing
                                                       avoidTunnel:( BOOL)avoidTunnel
                                                      avoidHighway:( BOOL)avoidHighway;


- (nonnull YMKDrivingAvoidanceFlags *)init;

@end
