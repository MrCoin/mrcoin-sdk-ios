//
//  MRCEmailViewController.m
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 05/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import "MRCEmailViewController.h"
#import "MRCFormViewController.h"
#import "MrCoin.h"
#import "MRCEmailData.h"

@interface MRCEmailViewController ()

@end

@implementation MRCEmailViewController

#pragma mark - Initialization
- (void)viewDidLoad {
    [super viewDidLoad];
    _emailTextInput.textInputDelegate = self;
    _emailTextInput.dataType = (MRCInputDataType*)[MRCEmailData dataType];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation
- (void)nextPage:(id)sender
{
    [_emailTextInput endEditing:YES];
    //
    [self showActivityIndicator:NSLocalizedString(@"Sending data to MrCoin...",nil)];
    //
    [[MrCoin api] email:_emailTextInput.text success:^(NSDictionary *dictionary) {
        [[MrCoin settings] setUserEmail:_emailTextInput.text];
        [super nextPage:sender];
    } error:^(NSError *error, MRCAPIErrorType errorType) {
    }];
}

#pragma mark - Text Input
- (void) textInput:(MRCTextInput *)textInput isValid:(BOOL)valid
{
    self.nextButton.enabled = valid;
}


@end
