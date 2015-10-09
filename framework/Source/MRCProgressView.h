//
//  MRCProgressView.h
//  MrCoin iOS SDK
//
//  Created by Gabor Nagy on 04/10/15.
//  Copyright © 2015 MrCoin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MRCProgressView : UIView

@property (nonatomic) NSArray *steps;
@property (nonatomic) IBInspectable NSInteger activeStep;

@end
