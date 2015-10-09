//
//  MRCFormViewController.m
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 05/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import "MRCFormViewController.h"
#import "MrCoin.h"

#define STEPS @[@"Terms of Service",@"Wallet key",@"Phone number",@"Phone verification",@"Email",@"Done"]
#define PAGES @[@"Form_Terms",@"Form_Wallet",@"Form_Phone",@"Form_VerifyPhone",@"Form_Email",@"Form_Done"]

@interface MRCFormViewController ()

@end

@implementation MRCFormViewController
{
    UIViewController *_currentViewController;
    NSInteger _page;
}
- (void)viewDidLoad {
    _page = -1;
    
    [super viewDidLoad];

    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.modalTransitionStyle   = UIModalTransitionStyleFlipHorizontal;
    self.modalPresentationStyle = UIModalPresentationFullScreen;

    [_progressView setSteps:STEPS];
}
-(void)viewDidAppear:(BOOL)animated
{
    [self nextPage];
}
- (void) loadPageNamed:(NSString*)pageName complete:(void (^ __nullable)(BOOL finished))completion
{
    UIViewController *newViewController = [MrCoin viewController:pageName];

    __block CGRect r = _contentView.bounds;
    CGRect r2 = r;
    r.origin.x = r.size.width;
    newViewController.view.frame = r;
    
    [_contentView addSubview:newViewController.view];
    
    [UIView animateWithDuration:0.5 animations:^{
        newViewController.view.frame = r2;
        if(_currentViewController){
            r.origin.x = -r.size.width;
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
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void) nextPage
{
    _page++;
    if(_page >= [PAGES count]){
        [[MrCoin settings] setConfigured:YES];
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }else{
        _progressView.activeStep = _page+1;
        //
        [self loadPageNamed:PAGES[_page] complete:^(BOOL finished) {
        }];
    }
}
- (void) previousPage
{
    _page--;
    if(_page >= 0){
        _progressView.activeStep = _page+1;
        [self loadPageNamed:PAGES[_page] complete:^(BOOL finished) {
        }];
    }
}

@end


