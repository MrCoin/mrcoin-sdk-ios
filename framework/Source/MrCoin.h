//
//  MrCoin.h
//  MrCoin IOS SDK
//
//  Created by Gabor Nagy on 04/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "MrCoinViewController.h"

#import "MRCFormViewController.h"
#import "MRCFormPageViewController.h"

#import "MRCEmptyViewController.h"
#import "MRCTransferViewController.h"

#import "MRCPopUpViewController.h"
#import "MRCTextViewController.h"
#import "MRCCurrencyTableViewController.h"

#import "MRCProgressView.h"
#import "MRCTextInput.h"
#import "MRCDropDown.h"
#import "MRCButton.h"
#import "MRCCopiableButton.h"

#import "MRCAPI.h"
#import "MRCSettings.h"

@interface MrCoin : NSObject

#define MRCOIN_URL      @"http://www.mrcoin.eu"
#define MRCOIN_SUPPORT  @"support@mrcoin.eu"

//#define MRCLocalizedString(key) \
//[[MrCoin frameworkBundle] localizedStringForKey:(key) value:@"" table:nil]
//
//#define MRCFormatedLocalizedString(key, value) \

@property (strong, readonly) MRCAPI *api;
@property MrCoinViewController* rootController;
@property BOOL needsAcceptTerms;

// Customizable
+ (void) customStoryboard:(UIStoryboard*)customStoryBoard;

+ (void)show:(id)target; // Valid target is window
+ (MRCTextViewController*)documentViewController:(MrCoinDocumentType)type;

+ (MrCoinViewController*) rootController;
+ (instancetype) sharedController;
+ (UIStoryboard*) storyboard;
+ (UIViewController*) viewController:(NSString*)named;
+ (MRCSettings*) settings;

- (UIStoryboard*) storyboard;
- (UIViewController*) viewController:(NSString*)named;
- (MRCSettings*) settings;

+ (NSBundle *)frameworkBundle;
+ (UIImage*) imageNamed:(NSString*)named;

+ (MRCAPI *)api;
@end