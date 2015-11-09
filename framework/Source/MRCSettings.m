//
//  MRCSettings.m
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 05/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import "MRCSettings.h"

@implementation MRCSettings

- (NSString *)destinationCurrency
{
    return @"BTC";
}
- (void) saveSettings
{
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    [d setObject:self.sourceCurrency forKey:@"MRCSourceCurrency"];
    [d synchronize];
}
- (void) resetSettings
{
    _userConfiguration = MRCUserConfigurationUnknown;
    _userPhone = nil;
    _userEmail = nil;
    _userCountryCode = nil;
    _userCountry = nil;
    _sourceCurrency = nil;
}
- (void) loadSettings
{
    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    self.sourceCurrency = [d objectForKey:@"MRCSourceCurrency"];
}

@end
