//
//  MRCSettings.h
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 05/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MRCSettings : NSObject

// Wallet
@property (nonatomic) NSString *walletPublicKey;
@property (nonatomic) NSString *walletPrivateKey;

// User settings
@property (nonatomic) NSString *userCountryCode;
@property (nonatomic) NSString *userPhone;
@property (nonatomic) NSString *userEmail;
@property (nonatomic) NSString *sourceCurrency;
@property (nonatomic,readonly) NSString *destinationCurrency;

// Temporary data
@property (nonatomic) NSArray *sourceCurrencies;

// Documents
@property (nonatomic) NSString *supportEmail;
@property (nonatomic) NSString *supportURL;
@property (nonatomic) NSString *termsURL;
@property (nonatomic) NSString *shortTermsURL;

@property (readonly) BOOL isConfigured;

- (void) loadSettings;
- (void) saveSettings;
- (void) resetSettings;

// Framework settings
@property (nonatomic) NSString *resellerKey;
@property (nonatomic) BOOL showPopupOnError;
@property (nonatomic) BOOL showErrorOnTextField;

@end
