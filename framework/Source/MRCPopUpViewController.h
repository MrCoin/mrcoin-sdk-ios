//
//  MRCPopUpViewController.h
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 10/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    MRCPopupMessage,
    MRCPopupActivityIndicator,
} MRCPopupMode;

typedef enum : NSUInteger {
    MRCPopupLightStyle,
    MRCPopupDarkStyle,
} MRCPopupStyle;

@interface MRCPopUpViewController : UIViewController //<UIViewControllerTransitioningDelegate>

@property (nonatomic) NSString *message;
@property (nonatomic) NSString *okLabel;
@property (nonatomic) BOOL hasOK;
@property (nonatomic) MRCPopupMode mode;
@property (nonatomic) MRCPopupStyle style;

- (IBAction)ok:(id)sender;
- (IBAction)cancel:(id)sender;

+ (instancetype) sharedPopup;

-(void)presentInViewController:(UIViewController *)viewController;
-(void)presentInViewController:(UIViewController *)viewController hideAfterDelay:(NSTimeInterval)delay;
-(void)dismissViewController;

+ (void) copiedFeedback:(UIViewController*)parentController;

@end
