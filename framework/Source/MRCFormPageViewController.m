//
//  MRCFormPageViewController.m
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 08/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import "MRCFormPageViewController.h"
#import "MRCFormViewController.h"
#import "MrCoin.h"

@interface MRCFormPageViewController ()

@end

@implementation MRCFormPageViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    if(self.nextButton) self.nextButton.enabled = NO;
}

- (MRCFormViewController*) formController
{
    return (MRCFormViewController*)self.parentViewController;
}

#pragma mark - Navigation
- (IBAction)nextPage:(id)sender
{
    [self.formController nextPage];
}
- (IBAction)previousPage:(id)sender
{
    [self.formController previousPage];
}
- (IBAction)nextPage:(id)sender withObject:(id)object
{
    [self.formController nextPageWithObject:object];
}
- (IBAction)previousPage:(id)sender withObject:(id)object
{
    [self.formController previousPageWithObject:object];
}

#pragma mark - Text Input
-(void)textInputStartEditing:(MRCTextInput *)textInput
{
    [[self formController] showOverlay:YES];
}
-(void)textInputEndEditing:(MRCTextInput *)textInput
{
    [[self formController] showOverlay:NO];
}
-(void)textInputFinishedEditing:(MRCTextInput *)textInput
{
    
}
-(void)textInputDone:(MRCTextInput*)textInput
{
    if(self.nextButton.enabled)
    {
        [self nextPage:self.nextButton];
    }
}
- (void)showError:(NSString*)title message:(NSString*)message textInput:(MRCTextInput*)textInput
{
    if([[MrCoin settings] showErrorOnTextField]){
        [textInput showError:title];
    }
    [[MrCoin sharedController] showErrorPopup:title message:message];
}


@end