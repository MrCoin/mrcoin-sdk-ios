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
#import "MRCTextViewController.h"
#import "MRCSettings.h"
#import "MRCAPI.h"

#define MRCOIN_URL      @"http://www.mrcoin.eu"
#define MRCOIN_SUPPORT  @"support@mrcoin.eu"

@protocol MrCoinDelegate <NSObject>

//(nonce + request method + request path + post data)
- (NSString*) requestMessageSignature:(NSString*)message privateKey:(NSString*)privateKey;
- (NSString*) requestDestinationAddress;
- (NSString*) requestPrivateKey;
- (NSString*) requestPublicKey;

@optional
- (void) quickTransferDidSetup;
- (void) quickTransferWillSetup;
- (void) quickTransferReset;

- (void) openURL:(NSURL*)url;
- (void) sendMail:(NSString*)to subject:(NSString*)subject;

- (void) setupViewController:(UIViewController*)viewController;
- (void) showErrors:(NSArray*)errors type:(MRCAPIErrorType)type;
- (void) hideErrorsPopup;
- (void) showActivityIndicator:(NSString*)message;
- (void) hideActivityIndicator;
@end

@interface MrCoin : NSObject

@property (strong, readonly) MRCAPI *api;
@property MrCoinViewController* rootController;
@property id <MrCoinDelegate> delegate;
@property BOOL needsAcceptTerms;

// Customizable
+ (void) customBundle:(NSBundle*)customBundle;

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

+ (void) setupQuickTransfer:(id)sender complete:(void (^)(void))complete cancel:(void (^)(void))cancel;
+ (void) resetQuickTransfer:(id)sender complete:(void (^)(void))complete cancel:(void (^)(void))cancel;

- (void) openURL:(NSURL*)url;
- (void) sendMail:(NSString*)to subject:(NSString*)subject;

+ (NSBundle *)frameworkBundle;
- (NSString*) localizedString:(NSString*)key;


- (void)showErrorPopup:(NSString*)title message:(NSString*)message;
- (void)showErrorPopup:(NSString*)title;
- (void)showErrors:(NSArray*)errors type:(MRCAPIErrorType)type;
- (void)hideErrorPopup;

- (void)showActivityIndicator:(NSString*)message;
- (void)showActivityIndicator;
- (void)hideActivityIndicator;
@end