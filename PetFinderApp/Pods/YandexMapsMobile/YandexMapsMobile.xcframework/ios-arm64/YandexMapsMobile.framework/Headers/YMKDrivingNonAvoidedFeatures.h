#import <Foundation/Foundation.h>

/**
 * Undocumented
 */
@interface YMKDrivingNonAvoidedFeatures : NSObject

/**
 * Undocumented
 */
@property (nonatomic, readonly) BOOL tolls;

/**
 * Undocumented
 */
@property (nonatomic, readonly) BOOL ferries;

/**
 * Undocumented
 */
@property (nonatomic, readonly) BOOL fordCrossings;

/**
 * Undocumented
 */
@property (nonatomic, readonly) BOOL highways;

/**
 * Undocumented
 */
@property (nonatomic, readonly) BOOL railwayCrossings;

/**
 * Undocumented
 */
@property (nonatomic, readonly) BOOL tunnels;

/**
 * Undocumented
 */
@property (nonatomic, readonly) BOOL inPoorConditionRoads;

/**
 * Undocumented
 */
@property (nonatomic, readonly) BOOL unpavedRoads;

/**
 * Undocumented
 */
@property (nonatomic, readonly) BOOL avoidZones;


+ (nonnull YMKDrivingNonAvoidedFeatures *)nonAvoidedFeaturesWithTolls:( BOOL)tolls
                                                              ferries:( BOOL)ferries
                                                        fordCrossings:( BOOL)fordCrossings
                                                             highways:( BOOL)highways
                                                     railwayCrossings:( BOOL)railwayCrossings
                                                              tunnels:( BOOL)tunnels
                                                 inPoorConditionRoads:( BOOL)inPoorConditionRoads
                                                         unpavedRoads:( BOOL)unpavedRoads
                                                           avoidZones:( BOOL)avoidZones;


@end
