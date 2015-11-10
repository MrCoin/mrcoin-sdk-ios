//
//  MrCointViewController.m
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 05/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import "MrCoinViewController.h"
#import "MrCoin.h"
#import "MRCAPI.h"
#import "MRCPopUpViewController.h"

@interface MrCoinViewController ()

@property (strong) MRCTransferViewController *page;
@property (strong) MRCEmptyViewController *unconfigured;

@end

@implementation MrCoinViewController
{
    BOOL verifyPhone;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [[MrCoin sharedController] setRootController:self];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)showView:(MRCUserConfigurationMode)configured
{
    if(configured == MRCUserConfigured){
        if(_unconfigured){
            [_unconfigured removeFromParentViewController];
            [_unconfigured.view removeFromSuperview];
            _unconfigured = nil;
        }
        if(!_page){
            [self showTransferView];
        }
    }else{
        if(!_unconfigured){
            if(_page){
                [_page removeFromParentViewController];
                [_page.view removeFromSuperview];
                _page = nil;
            }
            if(!_unconfigured){
                [self showUnconfigured];
            }
        }
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showView:[[MrCoin settings] userConfiguration]];
}
- (MRCEmptyViewController*) emptyViewController
{
    return _unconfigured;
}
- (MRCTransferViewController*) transferViewController
{
    return _page;
}

- (void)showTransferView
{
    _page = [MrCoin viewController:@"Transfer"];
    _page.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [[self view] addSubview:_page.view];
    [self addChildViewController:_page];
}
- (void)_showForm
{
    _page = [MrCoin viewController:@"Form"];
    _page.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [[self view] addSubview:_page.view];
    [self addChildViewController:_page];
}
- (void)showUnconfigured
{
    _unconfigured = [MrCoin viewController:@"Unconfigured"];
    _unconfigured.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [[self view] addSubview:_unconfigured.view];
    [self addChildViewController:_unconfigured];
}
- (IBAction) showForm:(id)sender;
{
    UIViewController *form = [MrCoin viewController:@"Form"];
    if(!sender) sender = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    
    [sender presentViewController:form animated:YES completion:^{
    }];
}
- (IBAction) showSettings:(id)sender;
{
    UIViewController *settings = [MrCoin viewController:@"Settings"];
    settings.view.backgroundColor = [UIColor whiteColor];
    if(self.navigationController){
        [self.navigationController pushViewController:settings animated:YES];
    }
//    [self presentViewController:form animated:YES completion:^{
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
