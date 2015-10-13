//
//  MRCEmailData.m
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 12/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import "MRCEmailData.h"

@implementation MRCEmailData

- (BOOL) isValid:(NSString*)string
{
    return [self _isValidEmail:string];
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

#pragma mark - Utilities
-(BOOL) _isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

@end
