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


#define MRCOIN_URL      @"http://www.mrcoin.eu"
#define MRCOIN_SUPPORT  @"support@mrcoin.eu"

@protocol MrCoinDelegate <NSObject>

//(nonce + request method + request path + post data)
- (NSString*) requestSignatureFor:(NSString*)message privateKey:(NSString*)privateKey;

@optional
- (void) openURL:(NSURL*)url;
- (void) sendMail:(NSString*)to subject:(NSString*)subject;

@end

@interface MrCoin : NSObject

@property (strong, readonly) MRCAPI *api;
@property MrCoinViewController* rootController;
@property id <MrCoinDelegate> delegate;
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

+ (UIImage*) imageNamed:(NSString*)named;

+ (MRCAPI *)api;

- (void) openURL:(NSURL*)url;
- (void) sendMail:(NSString*)to subject:(NSString*)subject;

+ (NSBundle *)frameworkBundle;
- (NSString*) localizedString:(NSString*)key;

@end