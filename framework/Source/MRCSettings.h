//
//  MRCSettings.h
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 05/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    MRCUserConfigurationUnknown,
    MRCUserUnconfigured,
    MRCUserPhoneConfigured,
    MRCUserConfigured
} MRCUserConfigurationMode;

@interface MRCSettings : NSObject

@property (nonatomic) NSLocale* locale;
@property (nonatomic) NSTimeZone* timeZone;

// User settings
@property (nonatomic) MRCUserConfigurationMode userConfiguration;
@property (nonatomic) NSString *userCountryCode;
@property (nonatomic) NSString *userPhone;
@property (nonatomic) NSString *userCountry;
@property (nonatomic) NSString *userEmail;
@property (nonatomic) NSString *sourceCurrency;
@property (nonatomic,readonly) NSString *destinationCurrency;
@property (nonatomic) NSString *quickTransferCode;

// Temporary data
//@property (nonatomic) NSArray *sourceCurrencies;

// Documents
@property (nonatomic) NSString *websiteURL;
@property (nonatomic) NSString *supportEmail;
@property (nonatomic) NSString *supportURL;
//@property (nonatomic) NSString *termsURL;
//@property (nonatomic) NSString *shortTermsURL;


- (void) loadSettings;
- (void) saveSettings;
- (void) resetSettings;

// Framework settings
@property (nonatomic) UIColor *formBackgroundColor;
@property (nonatomic) UIImage *formBackgroundImage;
@property (nonatomic) NSString *resellerKey;
@property (nonatomic) BOOL showPopupOnError;
@property (nonatomic) BOOL showActivityPopupOnLoading;
@property (nonatomic) BOOL showErrorOnTextField;

@end
