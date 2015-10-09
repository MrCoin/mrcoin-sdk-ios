//
//  MRCFormViewController.h
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 05/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MRCProgressView.h"

@interface MRCFormViewController : UIViewController

@property (weak, nonatomic) IBOutlet MRCProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
//
- (void) nextPage;
- (void) previousPage;

@end

