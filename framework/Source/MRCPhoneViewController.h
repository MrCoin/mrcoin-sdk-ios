//
//  MRCPhoneViewController.h
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 05/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRCFormPageViewController.h"
#import "MRCDropDown.h"

@interface MRCPhoneViewController : MRCFormPageViewController

@property (weak, nonatomic) IBOutlet MRCDropDown *countrySelector;
@property (weak, nonatomic) IBOutlet MRCTextInput *phoneTextInput;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

//- (IBAction)countrySelectorChanged:(id)sender;
//- (IBAction)phoneInputChanged:(id)sender;

@end
