//
//  MRCCopiableButton.h
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 07/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MRCCopiableButton : UIButton <UIActionSheetDelegate>

- (void)setLabel:(NSString *)label copyTitle:(NSString*)copyTitle copyLabel:(NSString*)copyLabel value:(NSString*)value;
- (IBAction)copyValue:(id)sender;

@end
