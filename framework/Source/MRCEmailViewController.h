//
//  MRCEmailViewController.h
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 05/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRCFormPageViewController.h"
#import "MRCTextInput.h"

@interface MRCEmailViewController : MRCFormPageViewController

@property (weak, nonatomic) IBOutlet MRCTextInput *emailTextInput;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@end
