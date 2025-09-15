#import <Foundation/Foundation.h>

/**
 * :nodoc:
 * The status of the current connection to the internet.
 */
typedef NS_ENUM(NSUInteger, YRTConnectivityStatus) {
    /**
     * No connection to the internet.
     */
    YRTConnectivityStatusNone,
    /**
     * Mobile network connection.
     */
    YRTConnectivityStatusCellular,
    /**
     * Network connection with high throughput (Wi-Fi or Ethernet).
     */
    YRTConnectivityStatusBroadband
};
