//
//  MRCSettings.h
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 05/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MRCSettings : NSObject

// User settings
@property (nonatomic) NSString *bitcoinAddress;
@property (nonatomic) NSString *userPhone;
@property (nonatomic) NSString *userEmail;
@property (nonatomic) NSString *sourceCurrency;
@property (nonatomic,readonly) NSString *destinationCurrency;
@property (readonly) BOOL isConfigured;

- (void) loadSettings;
- (void) saveSettings;
- (void) resetSettings;

// Framework settings
@property (nonatomic) NSString *resellerKey;
@property (nonatomic) BOOL showPopupOnError;
@property (nonatomic) BOOL showErrorOnTextField;

@end
