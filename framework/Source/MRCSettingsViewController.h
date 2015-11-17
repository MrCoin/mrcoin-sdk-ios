//
//  MRCSettingsViewController.h
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 12/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MRCSettingsViewController : UITableViewController

@property (nonatomic,copy) void (^onSetupComplete)(void);
@property (nonatomic,copy) void (^onSetupCancel)(void);

@property (nonatomic) BOOL showTerms;
@property (nonatomic) BOOL showHeaders;

@end
