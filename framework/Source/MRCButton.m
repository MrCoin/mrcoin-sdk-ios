//
//  MRCButton.m
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 07/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import "MRCButton.h"

@implementation MRCButton

#pragma mark - Initialization
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupControl];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupControl];
    }
    return self;
}
- (void) setupControl
{
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = 8;
}

@end
