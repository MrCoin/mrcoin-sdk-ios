//
//  MRCButton.m
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 07/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import "MRCButton.h"

@implementation MRCButton
{
    UIColor *_tintColor;
}
#pragma mark - Initialization
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.stroke = NO;
        self.fill = YES;
        self.cornerRadius = 10;
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
    _tintColor = self.tintColor;

    [self setupControl];
}
- (void) setupControl
{
    if(self.cornerRadius == -1){
        self.layer.cornerRadius = self.bounds.size.width*0.5f;
        self.layer.masksToBounds = YES;
    }else if(self.cornerRadius > 0){
        self.layer.cornerRadius = self.cornerRadius;
        self.layer.masksToBounds = YES;
    }else{
        self.layer.cornerRadius = 0;
        self.layer.masksToBounds = NO;
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
    if(self.cornerRadius == -1 || self.cornerRadius > 0){
        s.height += 14;
        s.width += 20;
    }
    return s;
}
-(void)setEnabled:(BOOL)enabled
{
    UIColor *sColor = [UIColor colorWithWhite:0 alpha:0.2];
    if(enabled){
        self.alpha = 1.0f;
        if(self.fill){
            [self setShadow:sColor];
            [self setTitleColor:[UIColor whiteColor]];
            self.backgroundColor = _tintColor;
        }else{
            [self setShadow:nil];
            [self setTitleColor:self.tintColor];
            self.backgroundColor = [UIColor clearColor];
        }
        if(self.stroke){
            self.layer.borderColor = _tintColor.CGColor;
            self.layer.borderWidth = 2.0f;
        }else{
            self.layer.borderColor = nil;
            self.layer.borderWidth = 0.0f;
        }
    }else{
        self.alpha = 0.5f;
        if(self.fill){
            [self setShadow:nil];
            [self setTitleColor:[UIColor darkGrayColor]];
            self.backgroundColor = nil;
        }else{
            [self setShadow:nil];
            [self setTitleColor:[UIColor darkGrayColor]];
            self.backgroundColor = nil;
        }
        if(self.stroke){
            self.layer.borderColor = [UIColor darkGrayColor].CGColor;
            self.layer.borderWidth = 2.0f;
        }else{
            self.layer.borderColor = nil;
            self.layer.borderWidth = 0.0f;
        }
    }
    [super setEnabled:enabled];
}
-(void)setTitleColor:(UIColor *)color
{
    self.tintColor = color;
    [self setTitleColor:color forState:UIControlStateNormal];
    [self setTitleColor:color forState:UIControlStateSelected];
    [self setTitleColor:color forState:UIControlStateHighlighted];
    [self setTitleColor:color forState:UIControlStateDisabled];
}
-(void)setImage:(UIImage *)image
{
    [self setImage:image forState:UIControlStateNormal];
    [self setImage:image forState:UIControlStateSelected];
    [self setImage:image forState:UIControlStateHighlighted];
    [self setImage:image forState:UIControlStateDisabled];
}
-(void)setShadow:(UIColor*)sColor
{
    if(sColor){
        self.titleLabel.shadowOffset = CGSizeMake(0, 1);
        [self setTitleShadowColor:sColor forState:UIControlStateNormal];
        [self setTitleShadowColor:sColor forState:UIControlStateSelected];
        [self setTitleShadowColor:sColor forState:UIControlStateHighlighted];
        [self setTitleShadowColor:sColor forState:UIControlStateDisabled];
        
        self.imageView.layer.shadowColor = sColor.CGColor;
        self.imageView.layer.shadowOffset = self.titleLabel.shadowOffset;
        self.imageView.layer.shadowOpacity = 1.0f;
        self.imageView.layer.shadowRadius = 0.0f;
    }else{
        self.titleLabel.shadowOffset = CGSizeZero;
        [self setTitleShadowColor:nil forState:UIControlStateNormal];
        [self setTitleShadowColor:nil forState:UIControlStateSelected];
        [self setTitleShadowColor:nil forState:UIControlStateHighlighted];
        [self setTitleShadowColor:nil forState:UIControlStateDisabled];
        
        self.imageView.layer.shadowColor = nil;
        self.imageView.layer.shadowOffset = CGSizeZero;
        self.imageView.layer.shadowOpacity = 0.0f;
        self.imageView.layer.shadowRadius = 0.0f;
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.3f delay:0.0f usingSpringWithDamping:0.8f initialSpringVelocity:0.5f options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.transform = CGAffineTransformMakeScale(0.8f, 0.8f);
    } completion:^(BOOL finished) {
        
    }];
    [super touchesBegan:touches withEvent:event];
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:1.0f delay:0.0f usingSpringWithDamping:0.3f initialSpringVelocity:1.5f options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
    [super touchesEnded:touches withEvent:event];
}
@end
