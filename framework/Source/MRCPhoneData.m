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
    if(!_format) _format = [[RMPhoneFormat alloc] init];
    return [_format isPhoneNumberValid:string];
}

- (NSString*) format:(NSString*)string
{
    if(!_format) _format = [[RMPhoneFormat alloc] init];
    return [_format format:string];
}
- (NSString*) unformat:(NSString*)string
{
    return [[string componentsSeparatedByString:@" "] componentsJoinedByString:@""];
}

- (NSInteger) minimumLength
{
    return 9;
}
- (NSInteger) maximumLength
{
    return -1;
}

@end
