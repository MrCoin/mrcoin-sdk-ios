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
#import "MRCInputDataType.h"

@interface MRCWalletAddressViewController ()

@end

@implementation MRCWalletAddressViewController

#pragma mark - Initialization
- (void)viewDidLoad {
    [super viewDidLoad];
    _publicKey.dataType = [[MRCInputDataType alloc] init];
    _publicKey.textInputDelegate = self;
    _privateKey.dataType = [[MRCInputDataType alloc] init];
    _privateKey.textInputDelegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation
-(void)nextPage:(id)sender
{
    [[MrCoin settings] setWalletPublicKey:_publicKey.text];
    [[MrCoin settings] setWalletPrivateKey:_privateKey.text];
    [_publicKey endEditing:YES];
    [_privateKey endEditing:YES];
    [super nextPage:sender];
}

#pragma mark - Text Input
-(BOOL)textInput:(MRCTextInput *)textInput changeText:(NSString *)string inRange:(NSRange)range
{
    NSString *newString = [textInput.text stringByReplacingCharactersInRange:range withString:string];
    textInput.text = newString;
    return NO;
}
-(void)textInput:(MRCTextInput *)textInput isValid:(BOOL)valid
{
    if(![_publicKey.text isEqualToString:@""] && ![_privateKey.text isEqualToString:@""]){
        self.nextButton.enabled = valid;
    }
}

@end
