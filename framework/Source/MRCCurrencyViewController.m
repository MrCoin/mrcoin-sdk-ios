//
//  MRCCurrencyViewController.m
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 09/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import "MrCoin.h"
#import "MRCCurrencyViewController.h"

@interface MRCCurrencyViewController ()

@end

@implementation MRCCurrencyViewController

#pragma mark - Initialization
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _currencySelector.items = @[@"HUF - Hungarian Forint",@"EUR - Eurozone euro"];
    _currencySelector.textInputDelegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Currency selector
- (IBAction)currencySelectorChanged:(id)sender
{
    if(_currencySelector.selectedRow >= 0){
        self.nextButton.enabled = YES;
    }else{
        self.nextButton.enabled = NO;
    }
}

#pragma mark - Navigation
- (void)nextPage:(id)sender
{
    [_currencySelector endEditing:YES];
    NSString *currency = [[_currencySelector.selectedItem componentsSeparatedByString:@" - "] firstObject];
    [[MrCoin settings] setSourceCurrency:currency];
    [[MrCoin settings] saveSettings];
    [super nextPage:sender];
}
@end
