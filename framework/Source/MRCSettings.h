//
//  MRCSettings.h
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 05/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MRCSettings : NSObject

//// Wallet
//@property (nonatomic) NSString *walletPublicKey;
//@property (nonatomic) NSString *walletPrivateKey;

@property (nonatomic) NSLocale* locale;
@property (nonatomic) NSTimeZone* timeZone;

// User settings
@property (nonatomic) NSString *userCountryCode;
@property (nonatomic) NSString *userPhone;
@property (nonatomic) NSString *userCountry;
@property (nonatomic) NSString *userEmail;
@property (nonatomic) NSString *sourceCurrency;
@property (nonatomic,readonly) NSString *destinationCurrency;

// Temporary data
@property (nonatomic) NSArray *sourceCurrencies;

// Documents
@property (nonatomic) NSString *website;
@property (nonatomic) NSString *supportEmail;
@property (nonatomic) NSString *supportURL;
@property (nonatomic) NSString *termsURL;
@property (nonatomic) NSString *shortTermsURL;

@property (readonly) BOOL isConfigured;

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
