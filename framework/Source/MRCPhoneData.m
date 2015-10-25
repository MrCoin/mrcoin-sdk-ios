//
//  MRCPhoneData.m
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 12/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import "MRCPhoneData.h"
#import "RMPhoneFormat.h"

@implementation MRCPhoneData
{
    RMPhoneFormat *_format;
}
- (BOOL) isValid:(NSString*)string
{
    return [_format isPhoneNumberValid:string];
}

@synthesize countryCode = _countryCode;
-(void)setCountryCode:(NSString *)countryCode
{
    _format = nil;
    _format = [[RMPhoneFormat alloc] initWithDefaultCountry:countryCode];
    _countryCode = countryCode;
}
-(NSString *)countryCode
{
    return _countryCode;
}


- (NSString*) format:(NSString*)string
{
    if(!_format) _format = [[RMPhoneFormat alloc] init];
    return [_format format:string];
}
- (NSString*) unformat:(NSString*)string
{
    NSString *s = [[string componentsSeparatedByString:@" "] componentsJoinedByString:@""];
    s = [[s componentsSeparatedByString:@"("] componentsJoinedByString:@""];
    s = [[s componentsSeparatedByString:@")"] componentsJoinedByString:@""];
    s = [[s componentsSeparatedByString:@"-"] componentsJoinedByString:@""];
    return s;
}

- (NSInteger) minimumLength
{
    return 9;
}
- (NSInteger) maximumLength
{
    return -1;
}
- (NSString*) defaultValue
{
    return self.prefix;
}

@end
