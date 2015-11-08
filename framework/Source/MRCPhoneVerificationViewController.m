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
#import "MrCoin.h"

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
    
    [[_codeTextInput valueForKey:@"textInputTraits"]
     setValue:[UIColor clearColor]
     forKey:@"insertionPointColor"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Text Input
- (void) textInput:(MRCTextInput *)textInput isValid:(BOOL)valid
{
    self.nextButton.enabled = valid;
}
-(void) textInputStartEditing:(MRCTextInput*)textInput
{
    _codeTextInput.text = @"";
}
#pragma mark - Actions
- (IBAction)resendVerificationCode:(id)sender
{
    _codeTextInput.text = @"";
    [_codeTextInput hideError];
    
    [[MrCoin api] phone:[[MrCoin settings] userPhone] country:[[MrCoin settings] userCountryCode] success:^(NSDictionary *dictionary) {
//        MRCPopUpViewController *popup = [MRCPopUpViewController sharedPopup];
    } error:nil];
    [[self view] setNeedsLayout];
//    MRCPopUpViewController *popup = [MRCPopUpViewController sharedPopup];
//    [popup setStyle:MRCPopupLightStyle];
//    [popup setMode:MRCPopupActivityIndicator];
//    [popup setTitle:NSLocalizedString(@"Resend verification code...",nil)];
//    [popup presentInViewController:self.parentViewController];
//
//    //
//    [self.api phone:[[MrCoin settings] userPhone] country:[[MrCoin settings] userCountry] success:^(NSDictionary *dictionary) {
//        [popup dismissViewController];
//    } error:^(NSError *error, MRCAPIErrorType errorType) {
//        
//    }];
}

- (IBAction)reenterPhoneNumber:(id)sender
{
    [self previousPage:sender];
}
#pragma mark - Navigation
- (void)nextPage:(id)sender
{
    [self.codeTextInput endEditing:YES];
    //
    [[MrCoin api] verifyPhone:_codeTextInput.text success:^(NSDictionary *dictionary) {
        [[MrCoin settings] setUserConfiguration:UserPhoneConfigured];
        MRCPopUpViewController *popup = [MRCPopUpViewController sharedPopup];
        [popup dismissViewController];
        [super nextPage:self];
    } error:nil];
}

@end
