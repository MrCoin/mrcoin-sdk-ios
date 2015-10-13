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
    if(self.nextButton) self.nextButton.enabled = NO;
}

- (MRCFormViewController*) formController
{
    return (MRCFormViewController*)self.parentViewController;
}
-(MRCAPI *)api
{
    if(self.formController){
        return self.formController.api;
    }
    return nil;
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
-(void)textInputDone:(MRCTextInput*)textInput
{
    if(self.nextButton.enabled)
    {
        [self nextPage:self.nextButton];
    }
}

#pragma mark - Error handling
-(void)showError:(NSString*)title message:(NSString*)message textInput:(MRCTextInput*)textInput
{
    if([[MrCoin settings] showErrorOnTextField]){
        [self showErrorTextInput:textInput error:title];
    }
    if([[MrCoin settings] showPopupOnError]){
        [self showErrorPopup:title message:message];
    }
}
-(void)showErrorPopup:(NSString*)title message:(NSString*)message
{
    MRCPopUpViewController *popup = [MRCPopUpViewController sharedPopup];
    [popup setStyle:MRCPopupLightStyle];
    [popup setMode:MRCPopupMessage];
    [popup setOkLabel:@"OK"];
    [popup setTitle:title];
    [popup setMessage:message];
    [popup presentInViewController:self.parentViewController];
}
-(void)showErrorTextInput:(MRCTextInput*)textInput error:(NSString*)title
{
    [textInput showError:title];
}


@end