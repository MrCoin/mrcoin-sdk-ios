//
//  MRCFormPageViewController.m
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 08/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import "MRCFormPageViewController.h"
#import "MRCFormViewController.h"

@interface MRCFormPageViewController ()

@end

@implementation MRCFormPageViewController

- (MRCFormViewController*) formController
{
    return (MRCFormViewController*)self.parentViewController;
}
- (IBAction)nextPage:(id)sender
{
    [self.formController nextPage];
}
- (IBAction)previousPage:(id)sender
{
    [self.formController previousPage];
}

@end