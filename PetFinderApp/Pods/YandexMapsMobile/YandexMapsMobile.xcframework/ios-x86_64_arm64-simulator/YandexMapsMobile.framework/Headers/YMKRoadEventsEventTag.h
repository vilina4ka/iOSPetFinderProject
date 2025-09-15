#import <Foundation/Foundation.h>

/**
 * Undocumented
 */
typedef NS_ENUM(NSUInteger, YMKRoadEventsEventTag) {
    /**
     * Undocumented
     */
    YMKRoadEventsEventTagOther,
    /**
     * Undocumented
     */
    YMKRoadEventsEventTagFeedback,
    /**
     * Undocumented
     */
    YMKRoadEventsEventTagChat,
    /**
     * Same as Chat but limited by distance that you can see it from
     */
    YMKRoadEventsEventTagLocalChat,
    /**
     * Temporary issues
     */
    YMKRoadEventsEventTagDrawbridge,
    /**
     * Undocumented
     */
    YMKRoadEventsEventTagClosed,
    /**
     * Undocumented
     */
    YMKRoadEventsEventTagReconstruction,
    /**
     * Undocumented
     */
    YMKRoadEventsEventTagAccident,
    /**
     * Potentially dangerous zones
     */
    YMKRoadEventsEventTagDanger,
    /**
     * Undocumented
     */
    YMKRoadEventsEventTagSchool,
    /**
     * Undocumented
     */
    YMKRoadEventsEventTagOvertakingDanger,
    /**
     * Undocumented
     */
    YMKRoadEventsEventTagPedestrianDanger,
    /**
     * Undocumented
     */
    YMKRoadEventsEventTagCrossRoadDanger,
    /**
     * Generalizing tag that has any traffic code control event. In old
     * clients all new events fallback to this tag
     */
    YMKRoadEventsEventTagPolice,
    /**
     * Traffic code control tags
     */
    YMKRoadEventsEventTagLaneControl,
    /**
     * Undocumented
     */
    YMKRoadEventsEventTagRoadMarkingControl,
    /**
     * Undocumented
     */
    YMKRoadEventsEventTagCrossRoadControl,
    /**
     * Undocumented
     */
    YMKRoadEventsEventTagNoStoppingControl,
    /**
     * Undocumented
     */
    YMKRoadEventsEventTagMobileControl,
    /**
     * Undocumented
     */
    YMKRoadEventsEventTagSpeedControl,
    /**
     * Undocumented
     */
    YMKRoadEventsEventTagTrafficControl,
    /**
     * Undocumented
     */
    YMKRoadEventsEventTagPolicePatrol
};
