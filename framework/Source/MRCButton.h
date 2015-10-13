//
//  MRCButton.h
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 07/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MRCButton : UIButton

@property (nonatomic) IBInspectable BOOL bordered;

- (void) setupControl;

@end
