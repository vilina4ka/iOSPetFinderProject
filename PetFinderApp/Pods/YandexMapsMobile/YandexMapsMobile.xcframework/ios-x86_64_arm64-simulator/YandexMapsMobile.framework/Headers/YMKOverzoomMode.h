#import <Foundation/Foundation.h>

/**
 * Undocumented
 */
typedef NS_ENUM(NSUInteger, YMKOverzoomMode) {
    /**
     * Overzoom is fully disabled.
     */
    YMKOverzoomModeDisabled,
    /**
     * If a tile is absent or translucent, tiles from lower or higher zooms
     * will be shown.
     */
    YMKOverzoomModeEnabled,
    /**
     * Same as Enabled, plus it fetches tiles well below absent or
     * translucent tiles that don't have any overzoom tiles to replace them
     * with.
     */
    YMKOverzoomModeWithPrefetch
};
