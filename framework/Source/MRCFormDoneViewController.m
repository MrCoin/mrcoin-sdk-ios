//
//  MRCFormDoneViewController.m
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 06/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import "MrCoin.h"
#import "MRCFormDoneViewController.h"
#import "MRCFormViewController.h"

@interface MRCFormDoneViewController ()

@end

@implementation MRCFormDoneViewController

#pragma mark - Initialization
- (void)viewDidLoad {
    [super viewDidLoad];
}
-(void)awakeFromNib
{
    self.nextButton.enabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
