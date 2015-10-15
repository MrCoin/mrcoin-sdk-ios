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
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
-(void)awakeFromNib
{
    [self setupControl];
}
- (void) setupControl
{
    if(_bordered){
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        [self setTitleColor:self.tintColor forState:UIControlStateNormal];
    }
    [self setEnabled:self.enabled];
}
- (CGSize)intrinsicContentSize
{
    CGSize s = [super intrinsicContentSize];
    if(self.hidden){
        s.height = 0;
        return s;
    }
    if(_bordered){
        s.height += 14;
        s.width += 20;
    }
    return s;
}
-(void)setEnabled:(BOOL)enabled
{
    if(enabled){
        if(_bordered){
            self.backgroundColor = self.tintColor;
            self.alpha = 1.0f;
        }else{
            [self setTitleColor:self.tintColor forState:UIControlStateNormal];
        }
    }else{
        if(_bordered){
            self.backgroundColor = [UIColor lightGrayColor];
            self.alpha = 0.5f;
        }else{
            [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
    }
    [super setEnabled:enabled];
}

@end
