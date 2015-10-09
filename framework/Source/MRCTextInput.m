//
//  MRCTextInput.m
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 05/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import "MRCTextInput.h"

@implementation MRCTextInput
{
    CGRect _originalFrame;
}

#pragma mark - Initialization
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.delegate = self;
    }
    return self;
}

#pragma mark - Functions
- (IBAction)doneEditing:(id)sender
{
    [self endEditing:YES];
    [self hide];
}
- (IBAction)cancelEditing:(id)sender
{
    self.text = @"";
    [self endEditing:YES];
    [self hide];
}

-(void)show
{
    [self addButtons];
    if(self.superview)
    {
        _originalFrame = self.superview.frame;
        CGRect f = _originalFrame;
        f.origin.y -= 150.0f;
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.superview.frame = f;
        } completion:^(BOOL finished) {
            
        }];
    }
}
-(void)hide
{
    if(self.superview)
    {
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.superview.frame = _originalFrame;
        } completion:^(BOOL finished) {
            
        }];
    }
}

#pragma mark - TextField Delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self show];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self hide];

}

#pragma mark - Toolbar
- (void)addButtons {
    UIToolbar* keyboardToolbar = [[UIToolbar alloc] init];
    [keyboardToolbar sizeToFit];
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil action:nil];
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                      target:self action:@selector(doneEditing:)];
    UIBarButtonItem *cancelBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                      target:self action:@selector(cancelEditing:)];
    keyboardToolbar.items = @[cancelBarButton,flexBarButton, doneBarButton];
    self.inputAccessoryView = keyboardToolbar;
}
@end
