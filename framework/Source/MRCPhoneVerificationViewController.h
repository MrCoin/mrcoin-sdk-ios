//
//  MRCPhoneVerificationViewController.h
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 06/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRCFormPageViewController.h"
#import "MRCTextInput.h"

@interface MRCPhoneVerificationViewController : MRCFormPageViewController

@property (weak, nonatomic) IBOutlet MRCTextInput *codeTextInput;
@property (weak, nonatomic) IBOutlet UIButton *resendButton;

//- (IBAction)resendVerificationCode:(id)sender;


@end
