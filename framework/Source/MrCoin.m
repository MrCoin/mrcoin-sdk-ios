//
//  MrCoin.m
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 04/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import "MrCoin.h"
//#import "MRCFormViewController.m"
#import "MRCPopUpViewController.h"

@class MRCFormViewController;

#define MRC_BUNDLE      @"MrCoin.bundle"
#define MRC_STORYBOARD  @"MrCoin"

@interface MrCoin ()

@property (strong) MRCSettings *userSettings;

@end

@implementation MrCoin


+ (void) setupQuickTransfer
{
    [[MrCoin rootController] showForm:nil];
}
+ (void) resetQuickTransfer
{
    [[MrCoin settings] resetSettings];
    [self setupQuickTransfer];
}



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
+ (void) checkUserDetails
{
    [[self api] getUserDetails:^(id result) {
        [[self settings] setConfigured:YES];
        NSLog(@"%@",result);
    } error:^(NSArray *errors, MRCAPIErrorType errorType) {
        [[self settings] setConfigured:NO];
        NSLog(@"%@",errors);
    }];
}
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
        _userSettings.sourceCurrency = @"EUR";
        _userSettings.showPopupOnError = YES;
        _userSettings.showErrorOnTextField = YES;
        
        _userSettings.supportEmail = @"support@mrcoin.eu";
        _userSettings.supportURL = @"https://www.mrcoin.eu/contact";
        _userSettings.shortTermsURL = @"https://www.mrcoin.eu/terms";
        _userSettings.websiteURL = @"http://www.mrcoin.eu";
        _userSettings.termsURL = @"https://www.mrcoin.eu/terms_full";
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

    
    if(type == MrCoinDocumentTerms){
        [vc setTitle:@"Terms"];
        [vc loadHTML:[[self settings] termsURL]];
    }else if(type == MrCoinDocumentShortTerms){
        [vc setTitle:@"Terms"];
        [vc loadHTML:[[self settings] shortTermsURL]];
    }else if(type == MrCoinDocumentSupport){
        [vc setTitle:@"Support"];
        [vc loadHTML:[[self settings] supportURL]];
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
static NSBundle* _frameworkBundle = nil;
+ (NSBundle *)frameworkBundle
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        NSString* mainBundlePath = [[NSBundle mainBundle] resourcePath];
        NSString* frameworkBundlePath = [mainBundlePath stringByAppendingPathComponent:MRC_BUNDLE];
        _frameworkBundle = [NSBundle bundleWithPath:frameworkBundlePath];
        
        if(!_frameworkBundle){
            NSString *path = [[[[NSBundle bundleForClass:[self class]] resourcePath] stringByDeletingLastPathComponent] stringByAppendingPathComponent:MRC_BUNDLE];
            _frameworkBundle = [NSBundle bundleWithPath:path];
        }
    });
    NSString *throwMessage = [NSString stringWithFormat:@"The resource file '%@' not found. See the README.",MRC_BUNDLE];
    NSAssert(_frameworkBundle, throwMessage);

    return _frameworkBundle;
}
+ (void) customBundle:(NSBundle*)customBundle
{
    if(!customBundle) return;
    _frameworkBundle = customBundle;
    _sharedStoryboard = nil;
}

#pragma mark - View Controllers
+ (UIViewController*) viewController:(NSString*)named
{
    return [[self sharedController] viewController:named];
}
- (UIViewController*) viewController:(NSString*)named
{
    if(self.storyboard){
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:named];
        if(self.delegate && [self.delegate respondsToSelector:@selector(setupViewController:)]){
            [self.delegate setupViewController:vc];
        }
        return vc;
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
#pragma mark - Localization
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

#pragma mark - Error handling
-(void)showErrorPopup:(NSString*)title message:(NSString*)message
{
    if(![[MrCoin settings] showPopupOnError]) return;
    MRCPopUpViewController *popup = [MRCPopUpViewController sharedPopup];
    [popup setStyle:MRCPopupLightStyle];
    [popup setMode:MRCPopupMessage];
    [popup setOkLabel:NSLocalizedString(@"OK",nil)];
    [popup setTitle:title];
    if(message)  [popup setMessage:message];
    [popup present];
}
-(void)showErrorPopup:(NSString*)title
{
    [self showErrorPopup:title message:nil];
}
- (void)showErrors:(NSArray*)errors type:(MRCAPIErrorType)type
{
    NSString *desc  = @"";
    for (NSError *error in errors) {
        desc = [desc stringByAppendingFormat:@"- %@\n",[error localizedDescription]];
    }
    [self showErrorPopup:NSLocalizedString(@"Something happend", NULL) message:desc];
    NSLog(@"%@",errors);
}
- (void)hideErrorPopup
{
    if(![[MrCoin settings] showPopupOnError]) return;
    if(self.delegate){
        if([self.delegate respondsToSelector:@selector(hideErrorPopup)]){
            [self.delegate hideErrorsPopup];
            return;
        }
    }
    MRCPopUpViewController *popup = [MRCPopUpViewController sharedPopup];
    [popup dismissViewController];
}
- (void)showActivityIndicator
{
    [self showActivityIndicator:nil];
}
- (void)showActivityIndicator:(NSString*)message
{
    if(![[MrCoin settings] showActivityPopupOnLoading]) return;
    if(self.delegate){
        if([self.delegate respondsToSelector:@selector(showActivityIndicator:)]){
            [self.delegate showActivityIndicator:message];
            return;
        }
    }
    MRCPopUpViewController *popup = [MRCPopUpViewController sharedPopup];
    [popup setStyle:MRCPopupLightStyle];
    [popup setMode:MRCPopupActivityIndicator];
    if(message) [popup setTitle:message];
    [popup present];
}
- (void)hideActivityIndicator
{
    if(![[MrCoin settings] showActivityPopupOnLoading]) return;
    if(self.delegate){
        if([self.delegate respondsToSelector:@selector(hideActivityIndicator)]){
            [self.delegate hideActivityIndicator];
            return;
        }
    }
    MRCPopUpViewController *popup = [MRCPopUpViewController sharedPopup];
    [popup dismissViewController];
}
@end