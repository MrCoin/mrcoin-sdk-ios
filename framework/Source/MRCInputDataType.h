//
//  MRCInputDataType.h
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 11/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MRCInputDataType : NSObject

+ (instancetype) dataType;

- (BOOL) isValid:(NSString*)string;

- (NSString*) format:(NSString*)string;
- (NSString*) unformat:(NSString*)string;

- (NSInteger) minimumLength;
- (NSInteger) maximumLength;

@end
