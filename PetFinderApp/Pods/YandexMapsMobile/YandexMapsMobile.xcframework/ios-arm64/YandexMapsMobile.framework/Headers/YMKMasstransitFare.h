#import <YandexMapsMobile/YMKTaxiMoney.h>

/**
 * Undocumented
 */
typedef NS_ENUM(NSUInteger, YMKMasstransitPaymentMediaMediaType) {
    /**
     * Undocumented
     */
    YMKMasstransitPaymentMediaMediaTypeUnknown,
    /**
     * Undocumented
     */
    YMKMasstransitPaymentMediaMediaTypeCash,
    /**
     * Undocumented
     */
    YMKMasstransitPaymentMediaMediaTypePaperTicket,
    /**
     * Undocumented
     */
    YMKMasstransitPaymentMediaMediaTypeTransitCard,
    /**
     * Bank cards, pay services in mobile phones - apple-pay, google-pay
     * etc.
     */
    YMKMasstransitPaymentMediaMediaTypeContactlessPaymentDevice,
    /**
     * Undocumented
     */
    YMKMasstransitPaymentMediaMediaTypeMobileApplication
};

/**
 * Undocumented
 */
@interface YMKMasstransitPaymentMedia : NSObject

/**
 * string which identifies the current media, can be used to select
 * icons im maps application.
 */
@property (nonatomic, readonly, nonnull) NSString *id;

/**
 * Localized name of the media, which is used for payment.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) NSString *name;

/**
 * Type of media, which is used for payment.
 */
@property (nonatomic, readonly) YMKMasstransitPaymentMediaMediaType type;


+ (nonnull YMKMasstransitPaymentMedia *)paymentMediaWithId:(nonnull NSString *)id
                                                      name:(nullable NSString *)name
                                                      type:( YMKMasstransitPaymentMediaMediaType)type;


@end

/**
 * Undocumented
 */
@interface YMKMasstransitPayment : NSObject

/**
 * Contains information about the payment media.
 *
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) YMKMasstransitPaymentMedia *paymentMedia;

/**
 * Cost of travel in the vehicle.
 */
@property (nonatomic, readonly, nonnull) YMKTaxiMoney *price;


+ (nonnull YMKMasstransitPayment *)paymentWithPaymentMedia:(nullable YMKMasstransitPaymentMedia *)paymentMedia
                                                     price:(nonnull YMKTaxiMoney *)price;


@end

/**
 * Undocumented
 */
typedef NS_ENUM(NSUInteger, YMKMasstransitSectionPaymentOptionAppliedFare) {
    /**
     * Undocumented
     */
    YMKMasstransitSectionPaymentOptionAppliedFareBoarding,
    /**
     * Undocumented
     */
    YMKMasstransitSectionPaymentOptionAppliedFareTransfer
};

/**
 * Undocumented
 */
@interface YMKMasstransitSectionPaymentOption : NSObject

/**
 * Optional field, can be nil.
 */
@property (nonatomic, readonly, nullable) YMKMasstransitPayment *payment;

/**
 * Undocumented
 */
@property (nonatomic, readonly) YMKMasstransitSectionPaymentOptionAppliedFare appliedFare;


+ (nonnull YMKMasstransitSectionPaymentOption *)sectionPaymentOptionWithPayment:(nullable YMKMasstransitPayment *)payment
                                                                    appliedFare:( YMKMasstransitSectionPaymentOptionAppliedFare)appliedFare;


@end

/**
 * Undocumented
 */
@interface YMKMasstransitRoutePaymentOption : NSObject

/**
 * Undocumented
 */
@property (nonatomic, readonly, nonnull) NSArray<YMKMasstransitPayment *> *payment;

/**
 * Undocumented
 */
@property (nonatomic, readonly, nonnull) NSArray<YMKTaxiMoney *> *totalPrice;


+ (nonnull YMKMasstransitRoutePaymentOption *)routePaymentOptionWithPayment:(nonnull NSArray<YMKMasstransitPayment *> *)payment
                                                                 totalPrice:(nonnull NSArray<YMKTaxiMoney *> *)totalPrice;


@end
