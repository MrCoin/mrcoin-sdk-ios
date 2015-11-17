//
//  MRCSettings.m
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 05/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import "MRCSettings.h"
#import "MrCoin.h"

@implementation MRCSettings

- (NSString *)destinationCurrency
{
    return @"BTC";
}

- (void) resetSettings
{
    self.userConfiguration = MRCUserConfigurationUnknown;
    self.userPhone = nil;
    self.userEmail = nil;
    self.userCountryCode = nil;
    self.userCountry = nil;
    self.quickTransferCode = nil;
    self.sourceCurrency = @"EUR";
}
- (void) loadSettings
{
    [[MrCoin api] getUserDetails:^(id result) {
        NSDictionary *attribs = [result objectForKey:@"attributes"];
        if(attribs){
            [self setSourceCurrency:attribs[@"currency"]];
            [self setUserConfiguration:MRCUserConfigured];
        }
    } error:^(NSArray *errors, MRCAPIErrorType errorType) {
        [self setUserConfiguration:MRCUserUnconfigured];
    }];
}
- (void) saveSettings
{
    [[MrCoin api] updateUserDetails:^(id result) {
        
    } error:^(NSArray *errors, MRCAPIErrorType errorType) {
        
    }];
}
@end
