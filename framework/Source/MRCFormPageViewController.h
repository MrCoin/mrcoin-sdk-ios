//
//  MRCFormPageViewController.h
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 08/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRCTextInput.h"
#import "MRCAPI.h"

@class MRCFormViewController;
@class MRCTextInput;

@interface MRCFormPageViewController : UIViewController <MRCTextInputDelegate>

@property (nonatomic) id object;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *prevButton;
//
- (MRCFormViewController*)formController;

- (IBAction)nextPage:(id)sender;
- (IBAction)previousPage:(id)sender;
- (void)nextPage:(id)sender withObject:(id)object;
- (void)previousPage:(id)sender withObject:(id)object;

- (void)showError:(NSString*)title message:(NSString*)message textInput:(MRCTextInput*)textInput;

@end
