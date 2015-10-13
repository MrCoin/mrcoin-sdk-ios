//
//  MrCoin.m
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 04/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import "MrCoin.h"

#define MRC_BUNDLE      @"MrCoin.bundle"
#define MRC_STORYBOARD  @"MrCoin"

@interface MrCoin ()

@property (strong) MRCSettings *userSettings;

@end

@implementation MrCoin

static MrCoin *_sharedController;
static UIStoryboard *_sharedStoryboard;

+ (void)show:(id)target
{
    if([target isKindOfClass:[UIWindow class]])
    {
        UIWindow *w = (UIWindow*)target;
        [w setRootViewController:[self viewController:@"MrCoin"]];
        [w makeKeyAndVisible];
    }
}
+ (instancetype) sharedController
{
    if(!_sharedController){
        _sharedController = [[MrCoin alloc] init];
        _sharedController.needsAcceptTerms = YES;
    }
    return _sharedController;
}

+ (MrCoinViewController*) rootController
{
    return _sharedController.rootController;
}

#pragma mark - Settings
+ (MRCSettings*) settings
{
    return [[self sharedController] settings];
}
- (MRCSettings*) settings
{
    if(!_userSettings){
        _userSettings = [[MRCSettings alloc] init];
        _userSettings.showPopupOnError = YES;
        _userSettings.showErrorOnTextField = YES;
        [_userSettings loadSettings];
    }
    return _userSettings;
}

#pragma mark - Utilities
+ (MRCTextViewController*)documentViewController:(MrCoinDocumentType)type
{
    MRCTextViewController *vc = (MRCTextViewController*)[self viewController:@"DocumentViewer"];
    vc.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    UIWindow *w = [[[UIApplication sharedApplication] delegate] window];
    vc.view.frame = w.frame;
    [vc setMode:MRCShowDocuments];
    [vc loadHTML:@""];
    if(type == MrCoinDocumentTerms){
        [vc setTitle:@"Terms"];
    }else if(type == MrCoinDocumentShortTerms){
        [vc setTitle:@"Terms"];
    }else if(type == MrCoinDocumentSupport){
        [vc setTitle:@"Support"];
    }
    return vc;
}
+ (UIImage*) imageNamed:(NSString*)named
{
    UIImage* img = [UIImage imageNamed:named];   // non-CocoaPods
    if (img == nil) img = [UIImage imageNamed:named inBundle:[self frameworkBundle] compatibleWithTraitCollection:nil];
    if (img == nil) img = [UIImage imageNamed:[NSString stringWithFormat:@"MrCoin.bundle/@%.png",named]]; // CocoaPod
    return img;
}

#pragma mark - Storyboard
+ (void) customStoryboard:(UIStoryboard*)customStoryBoard
{
    _sharedStoryboard = customStoryBoard;
}
+ (UIStoryboard*) storyboard
{
    return [[self sharedController] storyboard];
}
- (UIStoryboard*) storyboard
{
    if(!_sharedStoryboard){
        _sharedStoryboard = [UIStoryboard storyboardWithName:MRC_STORYBOARD bundle:[MrCoin frameworkBundle]];
    }
    return _sharedStoryboard;
}
+ (NSBundle *)frameworkBundle
{
    static NSBundle* frameworkBundle = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        NSString* mainBundlePath = [[NSBundle mainBundle] resourcePath];
        NSString* frameworkBundlePath = [mainBundlePath stringByAppendingPathComponent:MRC_BUNDLE];
        frameworkBundle = [NSBundle bundleWithPath:frameworkBundlePath];
    });
    return frameworkBundle;
}
#pragma mark - View Controllers
+ (UIViewController*) viewController:(NSString*)named
{
    return [[self sharedController] viewController:named];
}
- (UIViewController*) viewController:(NSString*)named
{
    if(self.storyboard){
        return [self.storyboard instantiateViewControllerWithIdentifier:named];
    }
    return nil;
}

@end