//
//  MRCFormPageViewController.h
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 08/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MRCFormViewController;

@interface MRCFormPageViewController : UIViewController

- (MRCFormViewController*) formController;
- (IBAction)nextPage:(id)sender;
- (IBAction)previousPage:(id)sender;

@end
