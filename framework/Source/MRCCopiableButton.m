//
//  MRCCopiableButton.m
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 07/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import "MRCCopiableButton.h"
#import "MRCPopUpViewController.h"

@interface MRCCopiableButton ()

@property (nonatomic) NSString *buttonLabel;
@property (nonatomic) NSString *value;
@property (nonatomic) NSString *alertTitle;
@property (nonatomic) NSString *alertLabel;

@end

@implementation MRCCopiableButton

#pragma mark - Configuration
-(void)setLabel:(NSString *)label copyTitle:(NSString*)copyTitle copyLabel:(NSString*)copyLabel value:(NSString*)value
{
    self.titleLabel.numberOfLines = 1;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.titleLabel.lineBreakMode = NSLineBreakByClipping;

    _buttonLabel = label;
    [self setTitle:label forState:UIControlStateNormal];
    [self addTarget:self action:@selector(copyValue:) forControlEvents:UIControlEventTouchUpInside];

    _alertLabel = copyLabel;
    _alertTitle = copyTitle;
    _value = value;
}
-(void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
}

#pragma mark - Copy to clipboard
- (IBAction)copyValue:(id)sender
{
    UIActionSheet *actionSheet = [UIActionSheet new];
    //"UIActionSheet is deprecated. Use UIAlertController with a preferredStyle of UIAlertControllerStyleActionSheet instead")
    actionSheet.title = _alertTitle;
    [actionSheet addButtonWithTitle:_alertLabel];
    [actionSheet addButtonWithTitle:NSLocalizedString(@"cancel", nil)];
    actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1;
    actionSheet.delegate = self;
    
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([title isEqual:_alertLabel]){
        [UIPasteboard generalPasteboard].string = _value;
        MRCPopUpViewController *popup = [MRCPopUpViewController sharedPopup];
        [popup setStyle:MRCPopupDarkStyle];
        [popup setMode:MRCPopupMessage];
        [popup setTitle:NSLocalizedString(@"Copied.",nil)];
        [popup setMessage:NSLocalizedString(@"The selected text successfully copied to the clipboard.", nil)];
        [popup presentInViewController:nil hideAfterDelay:2.0f];
    }
}
@end