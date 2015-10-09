//
//  ViewController.m
//  ObjCExample
//
//  Created by Gabor Nagy on 05/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import "ViewController.h"
#import <MrCoin/MrCoin.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    MrCoinView *v = [[MrCoinView alloc] initWithFrame:self.view.bounds];
//    MRCFormViewController *form = [MrCoin viewController:@"Form"];
//    
//    [[form view] setFrame:self.view.frame];
    [[self view] addSubview:v];
//    
//    NSLog(@"%@",form);
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
