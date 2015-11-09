//
//  MRCFormViewController.m
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 05/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import "MRCFormViewController.h"
#import "MrCoin.h"

#pragma mark - Internal Form Page Class

@interface MRCFormPage : NSObject

+(instancetype) pageWithTitle:(NSString*)title storyboardID:(NSString*)storyboardID showInProgressView:( BOOL)showInProgressView;
+(instancetype) pageWithTitle:(NSString*)title storyboardID:(NSString*)storyboardID;

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *storyboardID;
@property (nonatomic) BOOL showInProgressView;

@end

@implementation MRCFormPage
+(instancetype) pageWithTitle:(NSString*)title storyboardID:(NSString*)storyboardID showInProgressView:(BOOL)showInProgressView
{
    MRCFormPage *page = [[MRCFormPage alloc] init];
    if(page){
        page.title = title;
        page.storyboardID = storyboardID;
        page.showInProgressView = showInProgressView;
    }
    return page;
}
+(instancetype) pageWithTitle:(NSString*)title storyboardID:(NSString*)storyboardID
{
    return [self pageWithTitle:title storyboardID:storyboardID showInProgressView:YES];
}

@end

#pragma mark - Form View Overlay

@implementation MRCFormViewOverlay
{
    UIColor *_backgroundColor;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.topGradientSize = 50;
        self.bottomGradientSize = 100;
        self.userInteractionEnabled = NO;
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.topGradientSize = 50;
        self.bottomGradientSize = 100;
        self.userInteractionEnabled = NO;
    }
    return self;
}
- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    _backgroundColor = backgroundColor;
    [self setNeedsDisplay];
    super.backgroundColor = [UIColor clearColor];
}
-(UIColor *)backgroundColor
{
    return _backgroundColor;
}

-(UIColor*) clearColor:(UIColor*)uicolor
{
    return [self color:uicolor alpha:0.0f];
}
-(UIColor*) color:(UIColor*)uicolor alpha:(CGFloat)alpha
{
    CGColorRef color = [uicolor CGColor];
    int numComponents = (int)CGColorGetNumberOfComponents(color);
    
    UIColor *newColor;
    if (numComponents == 4)
    {
        const CGFloat *components = CGColorGetComponents(color);
        CGFloat red = components[0];
        CGFloat green = components[1];
        CGFloat blue = components[2];
        newColor = [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
    }
    return newColor;
}
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Create a gradient
    NSArray *colors = [NSArray arrayWithObjects:(id)[self color:_backgroundColor alpha:0.95].CGColor,(id)[self color:_backgroundColor alpha:0.5].CGColor, (id)[self clearColor:_backgroundColor].CGColor, nil];
//    CGFloat colors [] = {
//        1.0, 1.0, 1.0, 1.0,
//        1.0, 1.0, 1.0, 0.0
//    };
    CGFloat locations [] = {
        0.7, 0.9, 1.0
    };
    CGFloat locations2 [] = {
        0.0, 0.5, 1.0
    };
    
    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
    
    CGGradientRef gradient1 = NULL,gradient2 = NULL;
    CGPoint sPoint1 = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint ePoint1 = CGPointMake(CGRectGetMidX(rect), self.topGradientSize);
    CGPoint sPoint2 = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    CGPoint ePoint2 = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect)-self.bottomGradientSize);
    if(_documentMode){
        if(self.topGradientSize > 0){
            gradient1 = CGGradientCreateWithColors(baseSpace, (CFArrayRef)colors, locations2);
        }
        if(self.bottomGradientSize > 0){
            gradient2 = CGGradientCreateWithColors(baseSpace, (CFArrayRef)colors, locations);
        }
    }else{
        if(self.topGradientSize > 0){
            gradient1 = CGGradientCreateWithColors(baseSpace, (CFArrayRef)colors, locations);
        }
        if(self.bottomGradientSize > 0){
            gradient2 = CGGradientCreateWithColors(baseSpace, (CFArrayRef)colors, locations2);
        }
//        ePoint1.y = self.bottomGradientSize*1.5;
    }
    
    CGColorSpaceRelease(baseSpace), baseSpace = NULL;

    CGContextSaveGState(context);
    
    // Gradient

    if(self.topGradientSize > 0){
        CGContextDrawLinearGradient(context, gradient1, sPoint1, ePoint1, 0);
    }
    if(self.bottomGradientSize > 0){
        CGContextDrawLinearGradient(context, gradient2, sPoint2, ePoint2, 0);
    }
    CGGradientRelease(gradient1);
    CGGradientRelease(gradient2);
    gradient1 = NULL;
    gradient2 = NULL;
    
    CGContextRestoreGState(context);
}
@end


#pragma mark - Form View Controller

@interface MRCFormViewController ()

@property (weak, nonatomic) IBOutlet MRCProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentTop;

@end

@implementation MRCFormViewController
{
    UIViewController *_currentViewController;
    MRCFormViewOverlay *_overlay;
    NSInteger _page;
    NSArray *_pageNames;
    
    BOOL _animation;
    
    UIImageView *wallpaper;
}

#pragma mark - Initialization
- (void)viewDidLoad {
    [super viewDidLoad];

    if([[MrCoin settings] formBackgroundImage]){
        wallpaper = [[UIImageView alloc] initWithImage:[[MrCoin settings] formBackgroundImage]];
        wallpaper.contentMode = UIViewContentModeBottomLeft;
        wallpaper.clipsToBounds = YES;
        [self.view insertSubview:wallpaper atIndex:0];
    }

    // Create pages
    NSMutableArray *pages = [NSMutableArray array];
    if([[MrCoin sharedController] needsAcceptTerms])
    {
        [pages addObject:[MRCFormPage
                          pageWithTitle:NSLocalizedString(@"Terms of Service",nil)
                          storyboardID:@"DocumentViewer"
                          showInProgressView:NO]];
    }
    if([[MrCoin settings] userConfiguration] < UserPhoneConfigured)
    {
        // Load country list
        [[MrCoin api] getCountries:^(NSDictionary *dictionary) {
        } error:nil];

        [pages addObject:[MRCFormPage
                          pageWithTitle:NSLocalizedString(@"Phone number",nil)
                          storyboardID:@"Form_Phone"
                          showInProgressView:YES]];
        [pages addObject:[MRCFormPage
                          pageWithTitle:NSLocalizedString(@"Phone verification",nil)
                          storyboardID:@"Form_VerifyPhone"
                          showInProgressView:YES]];
    }
    if([[MrCoin settings] userConfiguration] < UserConfigured)
    {
        [pages addObject:[MRCFormPage
                          pageWithTitle:NSLocalizedString(@"Email",nil)
                          storyboardID:@"Form_Email"
                          showInProgressView:YES]];
    }
//    if(![[MrCoin settings] sourceCurrency])
//    {
//        [pages addObject:[MRCFormPage
//                          pageWithTitle:NSLocalizedString(@"Currency",nil)
//                          storyboardID:@"Form_Currency"
//                          showInProgressView:YES]];
//    }
    [pages addObject:[MRCFormPage
                      pageWithTitle:NSLocalizedString(@"Done",nil)
                      storyboardID:@"Form_Done"
                      showInProgressView:NO]];
    _pages = pages;
    
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.modalTransitionStyle   = UIModalTransitionStyleFlipHorizontal;
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    _animation = NO;
    
    // Setup progress view
    NSMutableArray *pageNames = [NSMutableArray array];
    for (MRCFormPage *page in _pages) {
        if(page.showInProgressView){
            [pageNames addObject:page.title];
        }
    }
    _progressView.showCloseButton = YES;
    _progressView.delegate = self;
    [_progressView setStepLabels:pageNames];
    
    // Overlay
    _overlay = [[MRCFormViewOverlay alloc] initWithFrame:self.view.bounds];
    _overlay.alpha = 0;
    _overlay.documentMode = NO;
    _overlay.topGradientSize = 160.0f;
    _overlay.bottomGradientSize = 0.0f;
    _overlay.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view insertSubview:_overlay aboveSubview:_contentView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)viewWillAppear:(BOOL)animated
{
    _animation = NO;
    _page = -1;
    [self nextPage];
    _animation = YES;
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated
{
    wallpaper.clipsToBounds = YES;
    [super viewWillAppear:animated];
}
#pragma mark - Progress View delegate
-(void)progressViewClosed:(MRCProgressView*)progressView
{
    [self _closeForm];
}
#pragma mark - Handle pages
- (void) _showPage:(id)object reverse:(BOOL)reverse
{
    CGRect wallpaperFrame;
    if(wallpaper){
        wallpaperFrame = wallpaper.frame;
        CGFloat max = wallpaper.image.size.width-self.view.frame.size.width;
        wallpaperFrame.origin.x = -(max/(CGFloat)_pages.count)*_page;
    }
    
    MRCFormPage *page = _pages[_page];
    if(page.showInProgressView){
        _progressTop.constant = -10;
        _contentTop.constant = 120;
        _progressView.hidden = NO;
    }else{
        _progressTop.constant = -130;
        _contentTop.constant = 0;
        _progressView.hidden = YES;
    }
    if(_animation){
        [UIView animateWithDuration:0.5 animations:^{
            [self.view layoutIfNeeded];
            if(wallpaper){
                wallpaper.frame = wallpaperFrame;
            }
        } completion:^(BOOL finished) {
            if(finished){
            }
        }];
    }else{
        [self.view layoutIfNeeded];
    }
    [_progressView setActiveStepByName:page.title];
    [self loadPageNamed:page.storyboardID reverseAnimation:reverse complete:^(BOOL finished) {
    }];
}
- (void) showOverlay:(BOOL)show
{
    if(!_overlay) return;
    [UIView animateWithDuration:0.25 animations:^{
        if(show){
            _overlay.alpha = 1;
        }else{
            _overlay.alpha = 0;
        }
    } completion:^(BOOL finished) {
        if(finished){
        }
    }];
}

- (void) loadPageNamed:(NSString*)pageName reverseAnimation:(BOOL)reverse complete:(void (^ __nullable)(BOOL finished))completion
{
    UIViewController *newViewController = [MrCoin viewController:pageName];
    __block CGRect r = _contentView.bounds;
    CGRect r2 = r;
    if(reverse){
        r.origin.x = -r.size.width;
    }else{
        r.origin.x = r.size.width;
    }
    newViewController.view.frame = r;
    
    if([newViewController isKindOfClass:[MRCTextViewController class]]){
        MRCTextViewController *vc = (MRCTextViewController*)newViewController;
        vc.mode = MRCTermsUserNeedsAcceptForm;
        vc.overlayView.backgroundColor = self.view.backgroundColor;
//        [vc loadHTML:[[MrCoin settings] termsURL]];
        [[MrCoin api] getTerms:^(id result) {
            [vc parseHTML:result];
        } error:nil];
        self.view.backgroundColor = [UIColor whiteColor];
        wallpaper.alpha = 0.2f;
    }else{
        wallpaper.alpha = 1.0f;
    }
        

    [_contentView addSubview:newViewController.view];
    
    if(_animation){
        [UIView animateWithDuration:0.5 animations:^{
            if(![newViewController isKindOfClass:[MRCTextViewController class]]){
                if([[MrCoin settings] formBackgroundColor]){
                    self.view.backgroundColor = [[MrCoin settings] formBackgroundColor];
                }else{
                    self.view.backgroundColor = [UIColor whiteColor];
                }
                if(_overlay)    _overlay.backgroundColor = self.view.backgroundColor;
                wallpaper.alpha = 1.0f;
            }

            newViewController.view.frame = r2;
            if(_currentViewController){
                if(reverse){
                    r.origin.x = r.size.width;
                }else{
                    r.origin.x = -r.size.width;
                }
                _currentViewController.view.frame = r;
            }
        } completion:^(BOOL finished) {
            if(finished){
                [_currentViewController.view removeFromSuperview];
                [_currentViewController removeFromParentViewController];
                _currentViewController = newViewController;
                [self addChildViewController:newViewController];
            }
        }];
    }else{
        if(![newViewController isKindOfClass:[MRCTextViewController class]]){
            if([[MrCoin settings] formBackgroundColor]){
                self.view.backgroundColor = [[MrCoin settings] formBackgroundColor];
            }else{
                self.view.backgroundColor = [UIColor whiteColor];
            }
            if(_overlay)    _overlay.backgroundColor = self.view.backgroundColor;
            wallpaper.alpha = 1.0f;
        }

        newViewController.view.frame = r2;
        if(_currentViewController){
            if(reverse){
                r.origin.x = r.size.width;
            }else{
                r.origin.x = -r.size.width;
            }
            _currentViewController.view.frame = r;
        }
        [_currentViewController.view removeFromSuperview];
        [_currentViewController removeFromParentViewController];
        _currentViewController = newViewController;
        [self addChildViewController:newViewController];
    }
}
- (void) nextPageWithObject:(id)object
{
    _page++;
    if(_page >= [_pages count]){
        [self done:self];
    }else{
        [self _showPage:object reverse:NO];
    }
}
- (void) previousPageWithObject:(id)object
{
    _page--;
    if(_page >= 0){
        [self _showPage:object reverse:YES];
    }else{
        [self cancel:self];
    }
}
- (void) nextPage
{
    [self nextPageWithObject:nil];
}
- (void) previousPage
{
    [self previousPageWithObject:nil];
}


#pragma mark - Cancel / Done
- (IBAction)cancel:(id)sender
{
    [self _closeForm];
}
- (IBAction)done:(id)sender
{
    [self _closeForm];
}

- (void) _closeForm
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
