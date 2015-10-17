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
    static MrCoin *_sharedController;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _sharedController = [[MrCoin alloc] init];
        _sharedController.needsAcceptTerms = YES;
    });
    return _sharedController;
}
#pragma mark - Root view controller
+ (MrCoinViewController*) rootController
{
    return [[MrCoin sharedController] rootController];
}

#pragma mark - API
+(MRCAPI *)api
{
    return [[self sharedController] api];
}
-(MRCAPI *)api
{
    static MRCAPI* _api = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _api = [[MRCAPI alloc] init];
    });
    return _api;
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

#pragma mark - Document Viewer
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

#pragma mark - Utilities
+ (UIImage*) imageNamed:(NSString*)named
{
    UIImage* img = [UIImage imageNamed:named];   // non-CocoaPods
    if (img == nil) img = [UIImage imageNamed:named inBundle:[self frameworkBundle] compatibleWithTraitCollection:nil];
    if (img == nil) img = [UIImage imageNamed:[NSString stringWithFormat:@"MrCoin.bundle/@%.png",named]]; // CocoaPod
    if (img == nil){
        NSString *throwMessage = [NSString stringWithFormat:@"The image '%@' not found. Check framework or main bunddle.",named];
        NSAssert(_sharedStoryboard, throwMessage);
    }
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
    NSString *throwMessage = [NSString stringWithFormat:@"The storyboard '%@' not found. See the README.",MRC_STORYBOARD];
    NSAssert(_sharedStoryboard, throwMessage);

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
        
        if(!frameworkBundle){
            NSString *path = [[[[NSBundle bundleForClass:[self class]] resourcePath] stringByDeletingLastPathComponent] stringByAppendingPathComponent:MRC_BUNDLE];
            frameworkBundle = [NSBundle bundleWithPath:path];
        }
    });
    NSString *throwMessage = [NSString stringWithFormat:@"The resource file '%@' not found. See the README.",MRC_BUNDLE];
    NSAssert(frameworkBundle, throwMessage);

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
#pragma mark - URL Related
- (void) openURL:(NSURL*)url
{
    if(self.delegate){
        if([self.delegate respondsToSelector:@selector(openURL:)]){
            [self.delegate openURL:url];
            return;
        }
    }
    [[UIApplication sharedApplication] openURL:url];
}
- (void) sendMail:(NSString*)to subject:(NSString*)subject
{
    if(self.delegate){
        if([self.delegate respondsToSelector:@selector(sendMail:subject:)]){
            [self.delegate sendMail:to subject:subject];
            return;
        }
    }
    /* create mail subject */
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"mailto:%@?subject=%@",
                                                [to stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
                                                [subject stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
    [[UIApplication sharedApplication] openURL:url];
}
- (NSString*) localizedString:(NSString*)key
{
    static NSBundle* languageBundle = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        NSString* path= [[MrCoin frameworkBundle] pathForResource:@"en" ofType:@"lproj"];
        languageBundle = [NSBundle bundleWithPath:path];
    });
    return [languageBundle localizedStringForKey:key value:@"" table:nil];
}


//    MRCTextViewController *text = [MrCoin documentViewController:MrCoinDocumentSupport];
//    [text.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[MrCoin imageNamed:@"close"] style:UIBarButtonItemStylePlain target:text action:@selector(close:)]];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:text];
//    nav.modalPresentationStyle = UIModalTransitionStyleFlipHorizontal;
//    [self presentViewController:nav animated:YES completion:^{
//
//    }];

@end