//
//  MrCoin.h
//  MrCoin IOS SDK
//
//  Created by Gabor Nagy on 04/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "MrCoinView.h"
#import "MrCoinViewController.h"

#import "MRCEmptyViewController.h"
#import "MRCTransferViewController.h"
#import "MRCFormViewController.h"

//#import "MRCPhoneViewController.h"
//#import "MRCEmailViewController.h"

#import "MRCProgressView.h"
#import "MRCTextInput.h"
#import "MRCDropDown.h"
#import "MRCButton.h"
#import "MRCCopiableButton.h"

#import "MRCAPI.h"
#import "MRCSettings.h"

@interface MrCoin : NSObject

@property MrCoinViewController* rootController;

// Customizable
+ (void) customStoryboard:(UIStoryboard*)customStoryBoard;

+ (MrCoinViewController*) rootController;
+ (instancetype) sharedController;
+ (UIStoryboard*) storyboard;
+ (UIViewController*) viewController:(NSString*)named;
+ (MRCSettings*) settings;

- (UIStoryboard*) storyboard;
- (UIViewController*) viewController:(NSString*)named;
- (MRCSettings*) settings;

+ (NSBundle *)frameworkBundle;

@end