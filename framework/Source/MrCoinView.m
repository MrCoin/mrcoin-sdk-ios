//
//  MrCoinView.m
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 04/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import "MrCoinView.h"
#import "MrCoin.h"

@implementation MrCoinView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self viewLoaded];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self viewLoaded];
    }
    return self;
}

- (void) viewLoaded
{
    self.backgroundColor = [UIColor whiteColor];
}

@end
