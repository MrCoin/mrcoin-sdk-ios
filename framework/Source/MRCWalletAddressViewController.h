//
//  MRCWalletAddressViewController.h
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 11/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRCFormPageViewController.h"
#import "MRCTextInput.h"

@interface MRCWalletAddressViewController : MRCFormPageViewController 

@property (weak, nonatomic) IBOutlet MRCTextInput *addressInput;

@end
