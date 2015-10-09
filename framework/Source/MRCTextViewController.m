//
//  MRCTextViewController.m
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 08/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import "MRCTextViewController.h"

@interface MRCTextViewController ()

@end

@implementation MRCTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _textView.textContainerInset = UIEdgeInsetsMake(70, 10, 0, 10);
    _textView.scrollIndicatorInsets = UIEdgeInsetsMake(94, 0, 0, 0);
    [_textView scrollRectToVisible:_textView.bounds animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
