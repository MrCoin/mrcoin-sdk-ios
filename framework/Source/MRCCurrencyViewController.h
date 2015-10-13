//
//  MRCCurrencyViewController.h
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 09/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRCDropDown.h"
#import "MRCFormPageViewController.h"

@interface MRCCurrencyViewController : MRCFormPageViewController 

@property (weak, nonatomic) IBOutlet MRCDropDown *currencySelector;

- (IBAction)currencySelectorChanged:(id)sender;

@end
