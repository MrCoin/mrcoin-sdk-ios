//
//  MRCWalletAddressViewController.m
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 11/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import "MRCWalletAddressViewController.h"
#import "MRCPopUpViewController.h"
#import "MrCoin.h"

@interface MRCWalletAddressViewController ()

@end

@implementation MRCWalletAddressViewController

#pragma mark - Initialization
- (void)viewDidLoad {
    [super viewDidLoad];
    _addressInput.textInputDelegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation
-(void)nextPage:(id)sender
{
    [[MrCoin settings] setBitcoinAddress:_addressInput.text];
    [_addressInput endEditing:YES];
    [super nextPage:sender];
}

#pragma mark - Text Input
-(BOOL)textInput:(MRCTextInput *)textInput changeText:(NSString *)string inRange:(NSRange)range
{
    if(_addressInput != textInput) return YES;
    NSString *newString = [textInput.text stringByReplacingCharactersInRange:range withString:string];
    _addressInput.text = newString;
    return NO;
}
- (BOOL)textInputIsValid:(MRCTextInput *)textInput
{
    self.nextButton.enabled = YES;
    return YES;
}

@end
