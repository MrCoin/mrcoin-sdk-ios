//
//  MRCPhoneVerificationViewController.m
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 06/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import "MRCPhoneVerificationViewController.h"
#import "MRCFormViewController.h"
#import "MRCAPI.h"
#import "MRCTextInput.h"
#import "MRCButton.h"
#import "MRCVerificationCode.h"
#import "MRCPopUpViewController.h"

@interface MRCPhoneVerificationViewController ()

@end

@implementation MRCPhoneVerificationViewController
#pragma mark - Initialization
- (void)viewDidLoad {
    [super viewDidLoad];
    //
    self.codeTextInput.textInputDelegate = self;
    _codeTextInput.font = [UIFont systemFontOfSize:70.0f];
    _codeTextInput.dataType = [[MRCVerificationCode alloc] init];
    
//    [[_codeTextInput valueForKey:@"textInputTraits"]
//     setValue:[UIColor clearColor]
//     forKey:@"insertionPointColor"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Text Input
- (void) textInput:(MRCTextInput *)textInput isValid:(BOOL)valid
{
    self.nextButton.enabled = valid;
}

#pragma mark - Actions
- (IBAction)resendVerificationCode:(id)sender
{
    _codeTextInput.text = @"";
    [_codeTextInput hideError];
    [[self view] setNeedsLayout];
    //
    [self.api requestVerificationCodeForCountry:@"" phone:@"" response:^(NSDictionary *dictionary) {
        
    } error:^(NSError *error, MRCAPIErrorType errorType) {
        
    }];
}
- (IBAction)reenterPhoneNumber:(id)sender
{
    [self previousPage:sender];
}
#pragma mark - Navigation
- (void)nextPage:(id)sender
{
    MRCPopUpViewController *popup = [MRCPopUpViewController sharedPopup];
    [popup setStyle:MRCPopupLightStyle];
    [popup setMode:MRCPopupActivityIndicator];
    [popup setTitle:@"Checking verification code..."];
    [popup presentInViewController:self.parentViewController hideAfterDelay:2.0f];
    //
    [self performSelector:@selector(fakeDelay2) withObject:nil afterDelay:2.0f];
    //
    [self.api verifyPhone:@"" code:_codeTextInput.text response:^(NSDictionary *dictionary) {
        [self.codeTextInput endEditing:YES];
    } error:^(NSError *error, MRCAPIErrorType errorType) {
        [self showErrorPopup:@"Invalid verification code" message:[NSString stringWithFormat:@"Verification code: '%@' is incorrect.",self.codeTextInput.text]];
        self.nextButton.enabled = NO;
        _codeTextInput.text = @"";
        [[self view] setNeedsLayout];
    }];
}
- (void) fakeDelay2
{
    [super nextPage:self];
}

@end
