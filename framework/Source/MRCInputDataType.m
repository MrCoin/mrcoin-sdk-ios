//
//  MRCInputDataType.m
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 11/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import "MRCInputDataType.h"

@implementation MRCInputDataType

+ (instancetype) dataType
{
    return [[self alloc] init];
}

- (BOOL) isValid:(NSString*)string
{
    return YES;
}

- (NSString*) format:(NSString*)string
{
    return string;
}
- (NSString*) unformat:(NSString*)string
{
    return string;
}

- (NSInteger) minimumLength
{
    return 1;
}
- (NSInteger) maximumLength
{
    return -1;
}

@end
