//
//  MrCointViewController.h
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 05/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRCTransferViewController.h"
#import "MRCEmptyViewController.h"

@interface MrCoinViewController : UIViewController

- (IBAction) showForm:(id)sender;
- (IBAction) showSettings:(id)sender;

- (MRCEmptyViewController*) emptyViewController;
- (MRCTransferViewController*) transferViewController;

@end
