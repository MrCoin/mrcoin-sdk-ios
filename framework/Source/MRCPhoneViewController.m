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

@interface MRCPhoneViewController ()

@property RMPhoneFormat *formater;

@end

@implementation MRCPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _formater = [[RMPhoneFormat alloc] initWithDefaultCountry:@"hu"];
    _sendButton.enabled = YES;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//- (IBAction)countrySelectorChanged:(id)sender
//{
//    if(self.countrySelector.selectedRow >= 0){
//        NSLog(@"Country selected: %@",(NSString*)self.countrySelector.selectedItem);
//        _phoneTextInput.enabled = YES;
//        _sendButton.enabled = NO;
//    }else{
//        _phoneTextInput.enabled = NO;
//        _sendButton.enabled = NO;
//    }
//}
//- (IBAction)phoneInputChanged:(id)sender
//{
//    NSLog(@"Validate phone number: %@",(NSString*)self.phoneTextInput.text);
//        _sendButton.enabled = YES;
//}
//
//


@end
