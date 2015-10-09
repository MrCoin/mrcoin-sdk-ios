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

+ (instancetype) sharedController
{
    if(!_sharedController) _sharedController = [[MrCoin alloc] init];
    return _sharedController;
}

+ (MrCoinViewController*) rootController
{
    return _sharedController.rootController;
}

+ (MRCSettings*) settings
{
    return [[self sharedController] settings];
}
- (MRCSettings*) settings
{
    if(!_userSettings){
        _userSettings = [[MRCSettings alloc] init];
    }
    return _userSettings;
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