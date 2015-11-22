//
//  MRCButton.h
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 07/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MRCButton : UIButton

@property (nonatomic) IBInspectable BOOL stroke;
@property (nonatomic) IBInspectable BOOL fill;
@property (nonatomic) IBInspectable BOOL contentHeightIsZeroWhenHidden;
@property (nonatomic) IBInspectable CGFloat cornerRadius;

- (void) setupControl;

@end
