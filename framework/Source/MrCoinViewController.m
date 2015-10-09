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

@interface MrCoinViewController ()

@property (weak) UIViewController *page;
@property (weak) UIViewController *unconfigured;

@end

@implementation MrCoinViewController

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
- (void)viewWillAppear:(BOOL)animated
{
    if([[MrCoin settings] isConfigured]){
        if(_unconfigured){
            [_unconfigured removeFromParentViewController];
            [_unconfigured.view removeFromSuperview];
            _unconfigured = nil;
        }
        [self showTransferView];
    }else{
        if(!_unconfigured){
            [self showUnconfigured];
        }
    }
}

- (void)showTransferView
{
    _page = [MrCoin viewController:@"Transfer"];
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
    [self presentViewController:form animated:YES completion:^{
    }];
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
