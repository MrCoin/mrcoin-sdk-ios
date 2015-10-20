//
//  MRCEmptyViewController.m
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 04/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import "MRCEmptyViewController.h"
#import "MRCFormViewController.h"
#import "MrCoin.h"

@implementation MRCEmptyViewController

- (IBAction)startConfiguration:(id)sender {
    [[MrCoin rootController] showForm:self];
}

@end
