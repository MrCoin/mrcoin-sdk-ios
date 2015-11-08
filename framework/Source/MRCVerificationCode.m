//
//  MRCVerificationCode.m
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 12/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import "MRCVerificationCode.h"

@implementation MRCVerificationCode

- (NSInteger) minimumLength
{
    return 4;
}
- (NSInteger) maximumLength
{
    return 4;
}
- (BOOL) isValid:(NSString*)string
{
    if(string.length < self.minimumLength)  return NO;
    if(string.length > self.maximumLength)  return NO;
    return [self _isValidCode:string];
}

#pragma mark - Utilities
-(BOOL) _isValidCode:(NSString *)checkString
{
    NSString *stricterFilterString = @"^[0-9]*$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stricterFilterString];
    return [emailTest evaluateWithObject:checkString];
}

@end
