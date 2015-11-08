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

@implementation MRCPhoneViewController

#pragma mark - Initialization
- (void)viewDidLoad {
    [super viewDidLoad];
    _countrySelector.textInputDelegate = self;
    //
    _phoneTextInput.textInputDelegate = self;
    _phoneTextInput.dataType = (MRCInputDataType*)[MRCPhoneData dataType];
    _phoneTextInput.placeholder = @"Your phone number";

    if(self.object){
        _countrySelector.text = [self.object objectForKey:@"country"];
        _phoneTextInput.text = [self.object objectForKey:@"phone"];
    }
    // Load country list
    if([[MrCoin api] countries]){
        [self configureDropdown:[[MrCoin api] countries]];
    }else{
        [[MrCoin api] addObserver:self forKeyPath:@"countries" options:(NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
    }
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if([MrCoin api] == object){
        if(![change[NSKeyValueChangeNewKey] isKindOfClass:[NSNull class]]){
            [self configureDropdown:change[NSKeyValueChangeNewKey]];
        }
    }
    //
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Country selector
- (IBAction)countrySelectorChanged:(id)sender
{
    if(self.countrySelector.selectedRow >= 0){
        // Change country, update API settings
        NSInteger index = self.countrySelector.selectedRow;
        [[MrCoin api] setCountry:[[[MrCoin api] countries] objectAtIndex:index]];
        [[MrCoin settings] setSourceCurrencies:[[[MrCoin api] country] valueForKeyPath:@"attributes.currencies"]];

        // TODO:
        [[MrCoin settings] setSourceCurrency:@"EUR"];
        //
        NSString *prefix = [[[MrCoin api] country] valueForKeyPath:@"attributes.phone_prefix"];
        // Configure validator
        MRCPhoneData* phoneData = (MRCPhoneData*)_phoneTextInput.dataType;
        [phoneData setPrefix:prefix];
//        [phoneData setCountryCode:<#(NSString *)#>]
        
        // Reset text input
        _phoneTextInput.placeholder = [NSString stringWithFormat:@"%@ (Your Phone number) ",prefix];
        _phoneTextInput.text = @"";
        
        // Reset navigation
        _phoneTextInput.enabled = YES;
        [_phoneTextInput becomeFirstResponder];
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
    NSString *phone = [_phoneTextInput.dataType unformat:_phoneTextInput.text];
    NSString *country = [[[[MrCoin api] country] valueForKeyPath:@"attributes.code2"] uppercaseString];
    [[MrCoin api] phone:phone country:country success:^(NSDictionary *dictionary) {
        MRCPopUpViewController *popup = [MRCPopUpViewController sharedPopup];
        [popup dismissViewController];
        [[MrCoin settings] setUserPhone:self.phoneTextInput.text];
        NSString *countryCode = [[[[MrCoin api] country] valueForKeyPath:@"attributes.code2"] lowercaseString];
        [[MrCoin settings] setUserCountryCode:countryCode];
        [super nextPage:self];
    } error:nil];
}
- (void) configureDropdown:(NSArray*)countries
{
    NSMutableArray *names = [NSMutableArray array];
    NSMutableArray *flags = [NSMutableArray array];
    for (NSDictionary *country in countries) {
        [names addObject:[country valueForKeyPath:@"attributes.localized_name"]];
        [flags addObject:[NSString stringWithFormat:@"flags/%@",[[country valueForKeyPath:@"attributes.code2"] lowercaseString]]];
    }
    _countrySelector.items = names;
    _countrySelector.iconItems = flags;
}

#pragma mark - Text Input
-(void)textInputStartEditing:(MRCTextInput *)textInput
{
    [super textInputStartEditing:textInput];
}
-(void)textInputFinishedEditing:(MRCTextInput *)textInput
{
    
}
- (void) textInput:(MRCTextInput *)textInput isValid:(BOOL)valid
{
    self.nextButton.enabled = valid;
}


@end
