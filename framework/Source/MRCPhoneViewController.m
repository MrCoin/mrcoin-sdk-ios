//
//  MRCPhoneViewController.m
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 05/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import "MRCPhoneViewController.h"
#import "MRCFormViewController.h"
#import "RMPhoneFormat.h"
#import "MRCPopUpViewController.h"
#import "MRCTextInput.h"
#import "MRCButton.h"
#import "MrCoin.h"
#import "MRCPhoneData.h"

@interface MRCPhoneViewController ()

@property RMPhoneFormat *formater;

@end

@implementation MRCPhoneViewController

#pragma mark - Initialization
- (void)viewDidLoad {
    [super viewDidLoad];
    _formater = [[RMPhoneFormat alloc] initWithDefaultCountry:@"hu"];
    //
    _countrySelector.textInputDelegate = self;
    //
    _phoneTextInput.textInputDelegate = self;
    _phoneTextInput.dataType = (MRCInputDataType*)[MRCPhoneData dataType];
    
    if(self.object){
        _countrySelector.text = [self.object objectForKey:@"country"];
        _phoneTextInput.text = [self.object objectForKey:@"phone"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Country selector
- (IBAction)countrySelectorChanged:(id)sender
{
    if(self.countrySelector.selectedRow >= 0){
//        NSLog(@"Country selected: %@",(NSString*)self.countrySelector.selectedItem);
        _phoneTextInput.enabled = YES;
        self.nextButton.enabled = NO;
    }else{
        _phoneTextInput.enabled = NO;
        self.nextButton.enabled = NO;
    }
}

#pragma mark - Navigation
- (void)nextPage:(id)sender
{
    [self.phoneTextInput endEditing:YES];
    //
    MRCPopUpViewController *popup = [MRCPopUpViewController sharedPopup];
    [popup setStyle:MRCPopupLightStyle];
    [popup setMode:MRCPopupActivityIndicator];
    [popup setTitle:@"Sending data to MrCoin..."];
    [popup presentInViewController:self.parentViewController hideAfterDelay:2.0f];
    //
    [self performSelector:@selector(fakeDelay2) withObject:nil afterDelay:2.0f];
    //
    [self.api requestVerificationCodeForCountry:_countrySelector.text phone:_phoneTextInput.text response:^(NSDictionary *dictionary) {
    } error:^(NSError *error, MRCAPIErrorType errorType) {
        
    }];
}
- (void) fakeDelay2
{
    [[MrCoin settings] setUserPhone:self.phoneTextInput.text];
    [super nextPage:self withObject:@{@"phone":_phoneTextInput.text,@"country":_countrySelector.text}];
}
#pragma mark - Text Input
-(void)textInputStartEditing:(MRCTextInput *)textInput
{
    if(!_countrySelector.items){
        MRCPopUpViewController *popup = [MRCPopUpViewController sharedPopup];
        [popup setStyle:MRCPopupLightStyle];
        [popup setMode:MRCPopupActivityIndicator];
        [popup setTitle:@"Fetching country list..."];
        [popup presentInViewController:self.parentViewController hideAfterDelay:2.0f];
        //
        [self performSelector:@selector(fakeDelay) withObject:nil afterDelay:2.0f];
    }
    [super textInputStartEditing:textInput];
}
- (void) fakeDelay
{
    _countrySelector.items = @[@"United Kingdom",@"Hungary"];
    [_countrySelector becomeFirstResponder];
//    [_countrySelector showPicker];
}
- (void) textInput:(MRCTextInput *)textInput isValid:(BOOL)valid
{
    self.nextButton.enabled = valid;
}


@end
